# syntax=docker/dockerfile:1

# === /2013/ — Jekyll =======================================================
FROM ruby:3.4-slim AS build-jekyll
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY blogs/jekyll/Gemfile blogs/jekyll/Gemfile.lock ./
RUN bundle install
COPY blogs/jekyll/ ./
RUN bundle exec jekyll build --destination /out

# === /2015/ — Hugo =========================================================
FROM alpine:3.22 AS build-hugo
RUN apk add --update --no-cache hugo
COPY blogs/hugo /src
RUN hugo --source /src --destination /out --minify

# === /2018/ — Gatsby =======================================================
FROM node:22-bookworm-slim AS build-gatsby
ENV CI=true
WORKDIR /src
COPY blogs/gatsby/package.json blogs/gatsby/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY blogs/gatsby/ ./
RUN npm run build && mv public /out

# === /2020/ — Next.js ======================================================
FROM node:22-bookworm-slim AS build-nextjs
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /src
COPY blogs/nextjs/package.json blogs/nextjs/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY blogs/nextjs/ ./
RUN npm run build && mv out /out

# === /2022/ — Astro ========================================================
FROM node:22-bookworm-slim AS build-astro
ENV ASTRO_TELEMETRY_DISABLED=1
WORKDIR /src
COPY blogs/astro/package.json blogs/astro/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY blogs/astro/ ./
RUN npm run build && mv dist /out

# === /2023/ — Eleventy =====================================================
FROM node:22-bookworm-slim AS build-eleventy
WORKDIR /src
COPY blogs/eleventy/package.json blogs/eleventy/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY blogs/eleventy/ ./
RUN npm run build && mv _site /out

# === /2024/ — Zola =========================================================
FROM alpine:3.22 AS build-zola
RUN apk add --update --no-cache zola
COPY blogs/zola /src
RUN zola --root /src build --output-dir /out --force

# === / — WordPress (the current incarnation) ==============================
FROM alpine:3.22 AS wordpress-dist
RUN apk add --update --no-cache curl unzip
ARG WP_VERSION=7.0
ARG WPCLI_VERSION=2.12.0
ARG TWENTYTEN_VERSION=4.6
RUN curl -fsSLO "https://wordpress.org/wordpress-${WP_VERSION}.tar.gz" \
    && echo "e50bb75667ecaa0eac0694fb3c7b024afc96fde0  wordpress-${WP_VERSION}.tar.gz" | sha1sum -c \
    && tar -xzf "wordpress-${WP_VERSION}.tar.gz" -C /
RUN curl -fsSL -o /usr/local/bin/wp \
        "https://github.com/wp-cli/wp-cli/releases/download/v${WPCLI_VERSION}/wp-cli-${WPCLI_VERSION}.phar" \
    && echo "be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832  /usr/local/bin/wp" | sha512sum -c \
    && chmod +x /usr/local/bin/wp
RUN curl -fsSLO "https://downloads.wordpress.org/theme/twentyten.${TWENTYTEN_VERSION}.zip" \
    && echo "fc1a037ef1a8ca8247c5f9d62ddfe28f2b19de474a5785b34a30f53496180e9c  twentyten.${TWENTYTEN_VERSION}.zip" | sha256sum -c \
    && unzip -q "twentyten.${TWENTYTEN_VERSION}.zip" -d /wordpress/wp-content/themes/
COPY blogs/wordpress/wp-config.php /wordpress/
COPY blogs/wordpress/mu-plugins /wordpress/wp-content/mu-plugins
COPY blogs/wordpress/content /blogoboros-content

# === runtime ===============================================================
FROM alpine:3.22
ARG S6_OVERLAY_VERSION=3.2.1.0
ADD "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" /tmp
ADD "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-aarch64.tar.xz" /tmp
ADD "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz" /tmp
RUN \
    sha256sum "/tmp/s6-overlay-noarch.tar.xz"; \
    echo "42e038a9a00fc0fef70bf0bc42f625a9c14f8ecdfe77d4ad93281edf717e10c5  /tmp/s6-overlay-noarch.tar.xz" | sha256sum -c; \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    \
    case "$(uname -m)" in \
        "x86_64") \
            sha256sum "/tmp/s6-overlay-x86_64.tar.xz"; \
            echo "8bcbc2cada58426f976b159dcc4e06cbb1454d5f39252b3bb0c778ccf71c9435  /tmp/s6-overlay-x86_64.tar.xz" | sha256sum -c; \
            tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz; \
            ;; \
        "aarch64") \
            sha256sum "/tmp/s6-overlay-aarch64.tar.xz"; \
            echo "c8fd6b1f0380d399422fc986a1e6799f6a287e2cfa24813ad0b6a4fb4fa755cc  /tmp/s6-overlay-aarch64.tar.xz" | sha256sum -c; \
            tar -C / -Jxpf /tmp/s6-overlay-aarch64.tar.xz; \
            ;; \
        *) \
          echo "Cannot build, missing valid build platform." \
          exit 1; \
    esac; \
    rm -rf "/tmp/*"; \
    apk add --update --no-cache \
        nginx \
        mariadb mariadb-client \
        php84 php84-fpm php84-phar php84-mysqli php84-curl php84-dom php84-xml \
        php84-simplexml php84-xmlreader php84-xmlwriter php84-mbstring php84-session \
        php84-ctype php84-iconv php84-openssl php84-zip php84-gd php84-opcache \
        php84-fileinfo php84-sodium php84-intl php84-exif php84-tokenizer

COPY --from=build-jekyll /out /var/www/blogoboros/2013
COPY --from=build-hugo /out /var/www/blogoboros/2015
COPY --from=build-gatsby /out /var/www/blogoboros/2018
COPY --from=build-nextjs /out /var/www/blogoboros/2020
COPY --from=build-astro /out /var/www/blogoboros/2022
COPY --from=build-eleventy /out /var/www/blogoboros/2023
COPY --from=build-zola /out /var/www/blogoboros/2024

COPY --from=wordpress-dist /wordpress /var/www/wordpress
COPY --from=wordpress-dist /usr/local/bin/wp /usr/local/bin/wp
COPY --from=wordpress-dist /blogoboros-content /usr/share/blogoboros
COPY scripts/seed-wordpress.sh /usr/local/bin/seed-wordpress

COPY etc /etc
COPY init-wrapper /
EXPOSE 8080
ENTRYPOINT ["/init-wrapper"]
