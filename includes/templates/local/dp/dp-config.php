<?php

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

require_once ABSPATH . 'sites/default/settings.php';

$databases['default']['default'] = array (
    'database' => 'VAR_DB_NAME',
    'username' => 'VAR_DB_USER',
    'password' => 'VAR_DB_PASS',
    'prefix' => 'VAR_DB_PREFIX',
    'host' => 'VAR_DB_HOST',
    'port' => '3306',
    'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
    'driver' => 'mysql',
);