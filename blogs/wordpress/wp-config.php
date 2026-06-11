<?php
/**
 * The current incarnation of Compiled Thoughts.
 *
 * A real WordPress, with a real database, dynamically rendering one post.
 * Nothing persists between boots; the blog is reseeded identically each time.
 * It literally cannot accumulate content. This is thematically load-bearing.
 */

define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'localhost:/run/mysqld/mysqld.sock');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

/*
 * WordPress owns the domain root; derive the canonical URL from the request
 * so the same image works on localhost and behind Fly's TLS terminator.
 */
$scheme = (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https') ? 'https' : 'http';
if ($scheme === 'https') {
    $_SERVER['HTTPS'] = 'on'; // keep is_ssl() honest behind the proxy
}
define('WP_HOME', $scheme . '://' . ($_SERVER['HTTP_HOST'] ?? 'localhost:8080'));
define('WP_SITEURL', WP_HOME);

/*
 * Salts are fixed and committed. The admin password is random and discarded
 * at seed time, the database is ephemeral, and the only secret this blog
 * ever held was how little writing was happening.
 */
define('AUTH_KEY',         'blogoboros-is-an-art-project-and-this-is-part-of-the-art-001');
define('SECURE_AUTH_KEY',  'blogoboros-is-an-art-project-and-this-is-part-of-the-art-002');
define('LOGGED_IN_KEY',    'blogoboros-is-an-art-project-and-this-is-part-of-the-art-003');
define('NONCE_KEY',        'blogoboros-is-an-art-project-and-this-is-part-of-the-art-004');
define('AUTH_SALT',        'blogoboros-is-an-art-project-and-this-is-part-of-the-art-005');
define('SECURE_AUTH_SALT', 'blogoboros-is-an-art-project-and-this-is-part-of-the-art-006');
define('LOGGED_IN_SALT',   'blogoboros-is-an-art-project-and-this-is-part-of-the-art-007');
define('NONCE_SALT',       'blogoboros-is-an-art-project-and-this-is-part-of-the-art-008');

$table_prefix = 'wp_';

define('WP_DEBUG', false);
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', true);

/* That's all, stop editing! Happy publishing. */

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
