[Spécifications](VAR_LINK_REDMINE/wiki) - 
[Environnements](VAR_LINK_REDMINE/wiki/Environnements) - 
[Services](VAR_LINK_REDMINE/wiki/Services) - 
[**Documentation**](VAR_LINK_REDMINE/wiki/Documentation)

# **Documentation**

# VAR_PROJECT_ID
WORDPRESS PROJECT

# Requirements
This project is built and maintain with [SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) Use it to easily work with multiple projects, from the local environment to production deployment.

[Install SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) or use at least with this [commands](local/local.md)

# Command

## Install
```
$ sp install ExtremeSensio/VAR_PROJECT_ID
```
_Clone project to your local folder ~/SENSIOPAL/$GITHUB_REPO_

## Up
```
$ sp up
```
_Go in project folder and start your local environement_

## Down
```
$ sp down
```
_Stop your local project with docker_

## Deploy*
```sh
$ sp deploy github

$ sp deploy staging

$ sp deploy preproduction

$ sp deploy production
```
_Deploy your code on each environement_

## Sync from*
```sh
$ sp sync from staging

$ sp sync from preproduction

$ sp sync from production
```
_Sync database and media from (staging/preproduction/production) to local_

## Sync to*
```sh
$ sp sync to staging

$ sp sync to preproduction

$ sp sync to production
```
_Sync database and media from local to (staging/preproduction/production)_

## Init/Reset
```
$ sp init
```
By editing SENSIOPAL file you need to rebuild the static project settings 

##### * require access by ssh key. Send your public key to server admin of the project.