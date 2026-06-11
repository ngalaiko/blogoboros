#!/usr/bin/env bash
# Walk the ouroboros: start the container, follow the "this blog has moved"
# banners from the living WordPress through every dead incarnation, and
# assert that the snake bites its tail.
set -euo pipefail

IMAGE="${1:-blogoboros}"
DOCKER="${DOCKER:-$(command -v docker || command -v podman)}"
PORT="${PORT:-8127}"
BASE="http://localhost:${PORT}"

# The ring, in banner order. Index 0 is the living blog.
EXPECTED=(/ /2013/ /2015/ /2018/ /2020/ /2022/ /2023/ /2024/)
PLATFORMS=(WordPress Jekyll Hugo Gatsby Next.js Astro Eleventy Zola)

CID="$("$DOCKER" run -d -p "${PORT}:8080" "$IMAGE")"
cleanup() {
    "$DOCKER" rm -f "$CID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "waiting for the blog to come up (nginx starts only after WordPress is seeded)..."
for i in $(seq 1 120); do
    if curl -fso /dev/null "$BASE/"; then
        break
    fi
    if [ "$i" -eq 120 ]; then
        echo "FAIL: container did not become ready within 120s" >&2
        "$DOCKER" logs "$CID" | tail -50 >&2
        exit 1
    fi
    sleep 1
done

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

# Strip scheme+host (WordPress emits absolute URLs), keep the path.
to_path() {
    sed -E 's|https?://[^/]+||' <<<"$1"
}

# Find an href to the given path; tolerates minified (unquoted) attributes.
has_link() {
    grep -qE "href=\"?${2}\"?[\" >]" <<<"$1"
}

cur="/"
for hop in 0 1 2 3 4 5 6 7; do
    [ "$cur" = "${EXPECTED[$hop]}" ] \
        || fail "hop $hop: expected ${EXPECTED[$hop]}, banner sent us to $cur"

    html="$(curl -fsS "$BASE$cur")" \
        || fail "hop $hop: $cur did not return 200"

    grep -q "How I migrated this blog from" <<<"$html" \
        || fail "hop $hop: $cur does not show the post title"

    # The only post: a uniform /YYYY/MM/slug/ permalink, whoever renders it.
    post_href="$(grep -oE 'href="?[^" >]*how-i-migrated[^" >]*' <<<"$html" | head -1 | sed -E 's/^href="?//')"
    [ -n "$post_href" ] || fail "hop $hop: no post link found on $cur"
    post_path="$(to_path "$post_href")"
    grep -qE '^/20[0-9]{2}/[0-9]{2}/how-i-migrated-this-blog-from-[a-z-]+/$' <<<"$post_path" \
        || fail "hop $hop: post permalink $post_path breaks the /YYYY/MM/slug/ contract"

    post_html="$(curl -fsS "$BASE$post_path")" \
        || fail "hop $hop: post $post_path did not return 200"

    prev="${EXPECTED[$(( (hop + 7) % 8 ))]}"
    has_link "$post_html" "$prev" \
        || fail "hop $hop: post $post_path does not link back to its previous life at $prev"

    # Follow the banner onward.
    next="$(grep -oE 'data-moved-to="?[^" >]*' <<<"$html" | head -1 | sed -E 's/^data-moved-to="?//')"
    [ -n "$next" ] || fail "hop $hop: no moved-banner on $cur"

    printf 'hop %d: %-9s %-7s post %-55s -> moved to %s\n' \
        "$hop" "${PLATFORMS[$hop]}" "$cur" "$post_path" "$next"
    cur="$next"
done

[ "$cur" = "/" ] || fail "after 8 hops we are at $cur, not back at the start"

echo
echo "OK: the snake bites its tail. 8 platforms, 8 posts, 1 blog, 0 content."
