# VAR_PROJECT_ID
WORDPRESS PROJECT

# Requirements
This project is built and maintain with [SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) Use it to easily work with multiple projects, from the local environment to production deployment.

[Install SENSIOPAL](https://github.com/ExtremeSensio/SENSIOPAL) or use at least with this [commands](local/local.md)

# Command

## Install
> Clone project to your local folder ~/SENSIOPAL/VAR_GITHUB_REPO
```
$ sensiopal install VAR_GITHUB_USER/VAR_GITHUB_REPO
```

## Up
> Go in project folder and start your local environement 
```
$ sensiopal up
```

## Down
> Stop your local project with docker
```
$ sensiopal down
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
$ sensiopal init
```
By editing SENSIOPAL file you need to rebuild the static project settings 

##### * require access by ssh key. Send your public key to server admin of the project.
