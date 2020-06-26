# LOCAL

This project is built and maintain with [SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) Use it to easily work with multiple projects, from the local environment to production deployment.

If you don't, you can still use local environement and deployement by full command :

### Installation requirements:

  - [x] [Docker](https://docs.docker.com/install/) for local environements
  - [x] [Docker Machine](https://docs.docker.com/machine/install-machine/) for local environements
  - [x] [Virtualbox](https://www.virtualbox.org/) for Docker Machine
  - [ ] [DPCLI](https://wp-cli.org/) for wordpress management
  - [ ] [HUB](https://hub.github.com/) for github tasks
  - [x] [DEPLOYER](https://deployer.org/download/) A deployment tool for PHP
  
> Execute commands bellow from the project root directory

## Init project
```
docker-machine create --driver virtualbox default 
docker-machine start default 
docker-machine env default
eval $(docker-machine env default)
docker-compose -f local/config.yml up -d --build --remove-orphans
```

## Up local environement
```
docker-machine start default 
docker-machine env default
eval $(docker-machine env default)
docker-compose -f local/config.yml up -d --build --remove-orphans
sudo -- sh -c -e "echo '$(docker-machine ip default) VAR_LOCAL_DOMAIN #local' >> /etc/hosts"
sudo -- sh -c -e "echo '$(docker-machine ip default) VAR_LOCAL_DOMAIN #local' >> /etc/hosts"
```

## Down  local environement
```
docker-compose -f local/config.yml down --remove-orphans
docker stop $(docker ps -a -q)
sudo -S sed -i '' "/#local/d" /etc/hosts
```

## Watch scss file
```
docker-compose -f local/config.yml exec sensiopal sh -c "/root/npm/node_modules/gulp/bin/gulp.js --gulpfile /root/npm/gulpfile.js --cwd /var/www/html" 

```

## Deploy staging
```
dep -f=local/dep/deploy-staging.php deploy
```

## Deploy preproduction
```
dep -f=local/dep/deploy-preproduction.php deploy
```

## Deploy production
```
dep -f=local/dep/deploy-production.php deploy
```
