#!/bin/sh
# Idempotent WordPress seeder. Runs on every boot; the database is ephemeral
# by design (the blog literally cannot accumulate content), so this script is
# the entire editorial history of the current incarnation.
set -eu

WP="php84 /usr/local/bin/wp --allow-root --path=/var/www/wordpress"
POST_SLUG="how-i-migrated-this-blog-from-zola-to-wordpress"
POST_DATE="2026-05-24 09:41:00"

echo "seed-wordpress: ensuring database exists"
mariadb --skip-ssl -e "
    CREATE DATABASE IF NOT EXISTS wordpress;
    CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
    FLUSH PRIVILEGES;
"

if ! $WP core is-installed 2>/dev/null; then
    echo "seed-wordpress: installing WordPress"
    $WP core install \
        --url="http://localhost:8080" \
        --title="Compiled Thoughts" \
        --admin_user="olav" \
        --admin_password="$(head -c 24 /dev/urandom | base64 | tr -d '+/=')" \
        --admin_email="olav@blogoboros.invalid" \
        --skip-email
fi

echo "seed-wordpress: configuring site"
$WP theme activate twentyten
$WP option update blogdescription "Olav Ringdal writes about software. There is a button that publishes."
$WP option update permalink_structure "/%year%/%monthnum%/%postname%/"
$WP rewrite flush --hard 2>/dev/null || $WP rewrite flush

# Remove the stock content so the archive stays a perfect monoculture.
for id in $($WP post list --post_type=post,page --name=hello-world,sample-page --format=ids); do
    $WP post delete "$id" --force
done

if [ -z "$($WP post list --name="$POST_SLUG" --format=ids)" ]; then
    echo "seed-wordpress: publishing THE post"
    $WP post create \
        --post_status=publish \
        --post_title="How I migrated this blog from Zola to WordPress" \
        --post_name="$POST_SLUG" \
        --post_date="$POST_DATE" \
        --post_author=1 \
        /usr/share/blogoboros/post.html
fi

POST_ID="$($WP post list --name="$POST_SLUG" --format=ids)"

if [ "$($WP comment list --post_id="$POST_ID" --format=count)" = "0" ]; then
    echo "seed-wordpress: delivering the only engagement this blog will ever receive"
    $WP comment create \
        --comment_post_ID="$POST_ID" \
        --comment_author="Best SEO Services" \
        --comment_author_email="contact@best-seo-services.example" \
        --comment_author_url="http://best-seo-services.example" \
        --comment_date="2026-05-24 09:58:00" \
        --comment_content="Great insights! I will definitely share this with my network. For anyone looking to grow their blog traffic organically, check out our proven link-building packages." \
        --comment_approved=1
fi

echo "seed-wordpress: done"
