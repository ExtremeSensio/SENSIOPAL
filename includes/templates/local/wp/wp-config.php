<?php

define( 'DB_NAME', 'VAR_DB_NAME' );

define( 'DB_USER', 'VAR_DB_USER' );

define( 'DB_PASSWORD', 'VAR_DB_PASS' );

define( 'DB_HOST', 'VAR_DB_HOST' );

define( 'DB_CHARSET', 'utf8mb4' );

define( 'DB_COLLATE', 'utf8mb4_unicode_ci' );

define( 'AUTH_KEY',          'VAR_SALT' );
define( 'SECURE_AUTH_KEY',   'VAR_SALT' );
define( 'LOGGED_IN_KEY',     'VAR_SALT' );
define( 'NONCE_KEY',         'VAR_SALT' );
define( 'AUTH_SALT',         'VAR_SALT' );
define( 'SECURE_AUTH_SALT',  'VAR_SALT' );
define( 'LOGGED_IN_SALT',    'VAR_SALT' );
define( 'NONCE_SALT',        'VAR_SALT' );
define( 'DP_CACHE_KEY_SALT', 'VAR_SALT' );

$table_prefix = 'VAR_DB_PREFIX';

define('DP_DEBUG', VAR_DEBUG);
define('SCRIPT_DEBUG', VAR_DEBUG );
define('DP_DEBUG_LOG', VAR_DEBUG );
define('DP_DEBUG_DISPLAY', VAR_DEBUG );

define('ALLOW_UNFILTERED_UPLOADS', true );

define('FS_METHOD', 'direct');

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

require_once ABSPATH . 'sites/default/settings.php';