[Spécifications](VAR_LINK_REDMINE/wiki) - 
[Environnements](VAR_LINK_REDMINE/wiki/Environnements) - 
[Services](VAR_LINK_REDMINE/wiki/Services) - 
[**Documentation**](VAR_LINK_REDMINE/wiki/Documentation)

# **Documentation**

# VAR_PROJECT_ID
DRUPAL PROJECT

# Requirements
This project is built and maintain with [SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) Use it to easily work with multiple projects, from the local environment to production deployment.

[Install SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) or use at least with this [commands](local/local.md)

# Command

## Install
```
$ sd install ExtremeSensio/VAR_PROJECT_ID
```
_Clone project to your local folder ~/SENSIOPAL/$GITHUB_REPO_

## Up
```
$ sd up
```
_Go in project folder and start your local environement_

## Down
```
$ sd down
```
_Stop your local project with docker_

## Deploy*
```sh
$ sd deploy github

$ sd deploy staging

$ sd deploy preproduction

$ sd deploy production
```
_Deploy your code on each environement_

## Sync from*
```sh
$ sd sync from staging

$ sd sync from preproduction

$ sd sync from production
```
_Sync database and media from (staging/preproduction/production) to local_

## Sync to*
```sh
$ sd sync to staging

$ sd sync to preproduction

$ sd sync to production
```
_Sync database and media from local to (staging/preproduction/production)_

## Init/Reset
```
$ sd init
```
By editing SENSIOPAL file you need to rebuild the static project settings 

##### * require access by ssh key. Send your public key to server admin of the project.