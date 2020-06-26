<?php
namespace Deployer;

require 'recipe/common.php';

host('VAR_SSH_IP')
    ->port( VAR_SSH_PORT )
    ->user( 'VAR_SSH_USER' );

set('ssh_type', 'native');
set('use_relative_symlinks', false);
set('ssh_multiplexing', true);
set('allow_anonymous_stats', false);
set('writable_use_sudo', false);
set('writable_mode', 'chmod');
set('http_user', 'www-data');

set('shared_dirs', ['wp-content/uploads']);
set('writable_dirs', ['wp-content']);

set('deploy_path', 'VAR_DIR' );

set('rsync_src', 'public');
set('rsync_dest','{{release_path}}');

set('rsync_app_src', 'app');
set('rsync_app_dest','{{release_path}}/wp-content/linotype');

set('rsync',[
    'exclude'      => [
        'wp-content/uploads/*',
        '*.log'
    ],
    'exclude-file' => false,
    'include'      => [],
    'include-file' => false,
    'filter'       => [],
    'filter-file'  => false,
    'filter-perdir'=> false,
    'flags'        => 'rz', // Recursive, with compress
    'options'      => ['delete'],
    'timeout'      => 3600,
]);

set('rsync_excludes', function () {
    $config = get('rsync');
    $excludes = $config['exclude'];
    $excludeFile = $config['exclude-file'];
    $excludesRsync = '';
    foreach ($excludes as $exclude) {
        $excludesRsync.=' --exclude=' . escapeshellarg($exclude);
    }
    if (!empty($excludeFile) && file_exists($excludeFile) && is_file($excludeFile) && is_readable($excludeFile)) {
        $excludesRsync .= ' --exclude-from=' . escapeshellarg($excludeFile);
    }

    return $excludesRsync;
});

set('rsync_includes', function () {
    $config = get('rsync');
    $includes = $config['include'];
    $includeFile = $config['include-file'];
    $includesRsync = '';
    foreach ($includes as $include) {
        $includesRsync.=' --include=' . escapeshellarg($include);
    }
    if (!empty($includeFile) && file_exists($includeFile) && is_file($includeFile) && is_readable($includeFile)) {
        $includesRsync .= ' --include-from=' . escapeshellarg($includeFile);
    }

    return $includesRsync;
});

set('rsync_filter', function () {
    $config = get('rsync');
    $filters = $config['filter'];
    $filterFile = $config['filter-file'];
    $filterPerDir = $config['filter-perdir'];
    $filtersRsync = '';
    foreach ($filters as $filter) {
        $filtersRsync.=" --filter='$filter'";
    }
    if (!empty($filterFile)) {
        $filtersRsync .= " --filter='merge $filterFile'";
    }
    if (!empty($filterPerDir)) {
        $filtersRsync .= " --filter='dir-merge $filterPerDir'";
    }
    return $filtersRsync;
});

set('rsync_options', function () {
    $config = get('rsync');
    $options = $config['options'];
    $optionsRsync = [];
    foreach ($options as $option) {
        $optionsRsync[] = "--$option";
    }
    return implode(' ', $optionsRsync);
});


desc('Warmup remote Rsync target');
task('rsync:warmup', function() {
    $config = get('rsync');

    $source = "{{deploy_path}}/current";
    $destination = "{{deploy_path}}/release";

    if (test("[ -d $(echo $source) ]")) {
        run("rsync -{$config['flags']} {{rsync_options}}{{rsync_excludes}}{{rsync_includes}}{{rsync_filter}} $source/ $destination/");
    } else {
        writeln("<comment>No way to warmup rsync.</comment>");
    }
});


desc('Rsync local->remote');
task('rsync', function() {
    $config = get('rsync');

    $src = get('rsync_src');
    while (is_callable($src)) {
        $src = $src();
    }

    if (!trim($src)) {
        throw new \RuntimeException('You need to specify a source path.');
    }

    $dst = get('rsync_dest');
    while (is_callable($dst)) {
        $dst = $dst();
    }

    if (!trim($dst)) {
        throw new \RuntimeException('You need to specify a destination path.');
    }

    $server = \Deployer\Task\Context::get()->getHost();
    if ($server instanceof \Deployer\Host\Localhost) {
        runLocally("rsync -{$config['flags']} {{rsync_options}}{{rsync_includes}}{{rsync_excludes}}{{rsync_filter}} '$src/' '$dst/'", $config);
        return;
    }

    $host = $server->getRealHostname();
    $port = $server->getPort() ? ' -p' . $server->getPort() : '';
    $sshArguments = $server->getSshArguments();
    $user = !$server->getUser() ? '' : $server->getUser() . '@';

    runLocally("rsync -{$config['flags']} --stats --progress -e 'ssh$port $sshArguments' {{rsync_options}}{{rsync_includes}}{{rsync_excludes}}{{rsync_filter}} '$src/' '$user$host:$dst/'", $config);
});

desc('Rsync App local->remote');
task('rsync_app', function() {
    $config = get('rsync');

    $src = get('rsync_app_src');
    while (is_callable($src)) {
        $src = $src();
    }

    if (!trim($src)) {
        throw new \RuntimeException('You need to specify a source path.');
    }

    $dst = get('rsync_app_dest');
    while (is_callable($dst)) {
        $dst = $dst();
    }

    if (!trim($dst)) {
        throw new \RuntimeException('You need to specify a destination path.');
    }

    $server = \Deployer\Task\Context::get()->getHost();
    if ($server instanceof \Deployer\Host\Localhost) {
        runLocally("rsync -{$config['flags']} {{rsync_options}}{{rsync_includes}}{{rsync_excludes}}{{rsync_filter}} '$src/' '$dst/'", $config);
        return;
    }

    $host = $server->getRealHostname();
    $port = $server->getPort() ? ' -p' . $server->getPort() : '';
    $sshArguments = $server->getSshArguments();
    $user = !$server->getUser() ? '' : $server->getUser() . '@';

    runLocally("rsync -{$config['flags']} --stats --progress -e 'ssh$port $sshArguments' {{rsync_options}}{{rsync_includes}}{{rsync_excludes}}{{rsync_filter}} '$src/' '$user$host:$dst/'", $config);
});

desc('Overwrite wp-config.php');
task('deploy:update_wp_config', function () {
    upload( 'local/dp/dp-config.VAR_FILE.php', '{{release_path}}/dp-config.php' );
});

task('deploy:chown', function () {
    run('chown -R www-data:www-data VAR_DIR');
});

//Deploy
task('deploy', [
    'deploy:info',
    'deploy:unlock',
    'deploy:prepare',
    'deploy:lock',
    'deploy:release',
    'rsync',
    'rsync_app',
    'deploy:shared',
    'deploy:update_wp_config',
    'deploy:writable',
    //'deploy:chown',
    'deploy:symlink',
    'deploy:unlock',
    'cleanup',
]);

after('deploy', 'success');

after('deploy:failed', 'deploy:unlock');