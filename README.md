# SENSIOPAL
CLI DRUPAL PROJECT MANAGER

![preview](preview.gif)

# Install

### Installation requirements:

  - [x] [Docker](https://docs.docker.com/install/) for local environements
  - [x] [Docker Machine](https://docs.docker.com/machine/install-machine/) for local environements
  - [x] [Virtualbox](https://www.virtualbox.org/) for Docker Machine
  - [x] [DrupalConsole](https://drupalconsole.com/) for Drupal management
  - [x] [HUB](https://hub.github.com/) for github tasks
  - [x] [DEPLOYER](https://deployer.org/download/) A deployment tool for PHP
  
## Bash install, for users:
> First, create a github developer token and replace $GITHUB_TOKEN with (contact yannick.armspach@sensiogrey.com for repo access) And execute...
```sh
curl -H "Authorization: token $GITHUB_TOKEN" -L https://raw.githubusercontent.com/ExtremeSensio/SENSIOPAL/master/install.sh | bash -s $GITHUB_TOKEN
```

## Git install, for contributor:
```sh
# Clone script
$ git clone git@github.com:ExtremeSensio/SENSIOPAL.git ~/SENSIOPAL_sh
# Add script to bash profile:
$ echo "source ~/SENSIOPAL_sh/sensiopal.sh" >> ~/.bash_profile
# Add alias to bash profile:
$ echo "alias sd='sensiopal'" >> ~/.bash_profile
```

# Command

## List
> List all your projects locate in ~/SENSIOPAL
```
$ sensiopal ls
```



## Open
> Go in project folder without starting local environement
```
$ sensiopal open [project_id]
```



## Up
> Go in project folder and start your local environement with docker. 
```
$ sensiopal up [project_id]
```
##### If you are already in project folder, you don't need to declare the \[project_id\]

## Create
> Create new project auto located in ~/SENSIOPAL
```
$ sensiopal new [project_id]
```


## Down
> Stop your local project with docker
```
$ sensiopal down [project_id]
```


## Kill
> Stop all docker container and ask to delete them
```
$ sensiopal kill
```



## Deploy*
> Deploy your code on each environement
```sh
$ sensiopal deploy github

$ sensiopal deploy staging

$ sensiopal deploy preproduction

$ sensiopal deploy production
```



## Sync from*
> Sync database and media from (staging/preproduction/production) to local
```sh
$ sensiopal sync from staging

$ sensiopal sync from preproduction

$ sensiopal sync from production
```


## Sync to*
> Sync database and media from local to (staging/preproduction/production)
```sh
$ sensiopal sync to staging

$ sensiopal sync to preproduction

$ sensiopal sync to production
```

## Init/Reset
```
$ sensiopal init [project_id]
```
By editing SENSIOPAL file you need to rebuild the static project settings 

##### * require access by ssh key. Send your public key to server admin of the project.