<?php
namespace Deployer;

require 'recipe/common.php';

set('ssh_type', 'native');
set('use_relative_symlinks', false);
set('ssh_multiplexing', true);
set('allow_anonymous_stats', false);
set('writable_use_sudo', false);
set('writable_mode', 'chmod');
set('http_user', 'www-data');

host('VAR_SSH_IP')
    ->port( VAR_SSH_PORT )
    ->user( 'VAR_SSH_USER' )
    ->set('deploy_path', 'VAR_DIR' );

task('sync:media', function () {
    download( 'VAR_DIR/shared/sites/default/files/', 'public/sites/default/files/' );
});

task('sync:db', function () {
    run('mysqldump --host=VAR_DB_HOST --user=VAR_DB_USER --password=VAR_DB_PASS VAR_DB_NAME > VAR_DIR/VAR_FILE.sql');
    download( 'VAR_DIR/VAR_FILE.sql', 'local/db/VAR_FILE.sql'  );
    run('rm VAR_DIR/VAR_FILE.sql');
});

task('sync', [
    'sync:media',
    'sync:db'
]);