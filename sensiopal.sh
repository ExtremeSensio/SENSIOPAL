#!/bin/bash

function sensiopal()
{

    unset ARG1
    ARG1="$1"
    unset ARG2
    ARG2="$2"
    unset ARG3
    ARG3="$3"

    SCRIPT_PATH=$(dirname "$BASH_SOURCE")

    SCRIPT_DIR=~/.SENSIOPAL

    GITHUB_TOKEN=X

    if [ -e $SCRIPT_DIR/token ] 
        then
            GITHUB_TOKEN=$(cat $SCRIPT_DIR/token)

    fi

    SENSIOPAL_SCRIPT_VERSION=0
    
    if [ -e $SCRIPT_DIR/version ] 
        then
            SENSIOPAL_SCRIPT_VERSION=$(cat $SCRIPT_DIR/version)

    fi
    
    if [ $(basename $(pwd)) != SENSIOPAL ]
        then
        echo "$(tput setaf 6)"
        echo "   _________  ______________  ___  ____ __"
        echo "  / __/ __/ |/ / __/  _/ __ \/ _ \/ _  / /"
        echo " _\ \/ _//    /\ \_/ // /_/ / ___/ _  / / "
        echo "/___/___/_/|_/___/___/\____/_/  /_//_/___/"
        echo "----------------- DRUPAL PROJECT MANAGER v.$SENSIOPAL_SCRIPT_VERSION"
        echo "$(tput setaf 7)"
    fi

    sensiopal_conf

    CONNECTED=$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')

    if [ -e $CONNECTED ]; 
        then
            echo "$(tput setaf 1)You are offline, we can't check if SENSIOPAL is up to date. Your project can not run as expected.$(tput setaf 7)"
        else
            sensiopal_check_script_version
    fi

    mkdir -p ~/SENSIOPAL

    case $ARG1 in
        --help)   
            sensiopal_help
        ;;
        info)
            sensiopal_ready
        ;;
        ls)
            sensiopal_list
        ;;
        open)
            sensiopal_open
        ;;
        new)
            sensiopal_new
        ;;
        init)
            sensiopal_init
        ;;
        install)
            sensiopal_install
        ;;
        watch)
            sensiopal_watch
        ;;
        db)
            if [ $PROJECT_ID ] 
                then
                    case $ARG2 in
                        import)   
                            case $ARG3 in

                                staging)                sensiopal_db_local_import_staging ;;

                                preproduction)          sensiopal_db_local_import_preproduction ;;
                                
                                production)             sensiopal_db_local_import_production ;;

                                *)                      sensiopal_db_local_import ;;
                            esac
                        ;;
                        export)   
                            sensiopal_db_local_export
                        ;;
                        *) echo "$(tput setaf 1)SENSIOPAL::ERROR - require import or export args$(tput setaf 7)" ;;
                    esac
                else
                    echo "$(tput setaf 1)SENSIOPAL::ERROR - require project folder$(tput setaf 7)"
            fi
               
        ;;
        up)
            sensiopal_up
        ;;
        down)     
            sensiopal_down
        ;;
        kill)   
            sensiopal_kill
        ;;
        logs)
            sensiopal_logs
        ;;
        delete)   
            sensiopal_delete
        ;;
        sync)
            case $ARG2 in

                to)                sensiopal_sync_to ;;

                from)              sensiopal_sync_from ;;

                *)                 sensiopal_help ;;
            esac
        ;;
        deploy)
            case $ARG2 in

                github)                 sensiopal_deploy_github ;;

                staging)                sensiopal_deploy_staging ;;
                staging:rights)         sensiopal_deploy_staging_rights ;;

                preproduction)          sensiopal_deploy_preproduction ;;
                preproduction:rights)   sensiopal_deploy_preproduction_rights ;;

                production)             sensiopal_deploy_production ;;
                production:rights)      sensiopal_deploy_production_rights ;;

                *)                      sensiopal_help ;;
            esac
        ;;
        deploy:sftp)
            case $ARG2 in

                staging)                sensiopal_deploy_sftp_staging ;;

                preproduction)          sensiopal_deploy_sftp_preproduction ;;

                production)             sensiopal_deploy_sftp_production ;;

                *)                      sensiopal_help ;;

            esac
        ;;
        deploy:sftp:update)
            case $ARG2 in

                staging)                sensiopal_deploy_sftp_staging_update ;;

                preproduction)          sensiopal_deploy_sftp_preproduction_update ;;

                production)             sensiopal_deploy_sftp_production_update ;;

                *)                      sensiopal_help ;;

            esac
        ;;
        rollback)
            case $ARG2 in

                staging)                sensiopal_rollback_staging ;;
                preproduction)          sensiopal_rollback_preproduction ;;
                production)             sensiopal_rollback_production ;;
                *)                      sensiopal_help ;;

            esac
        ;;
        ssh)
            case $ARG2 in

                staging)                sensiopal_ssh_staging ;;
                preproduction)          sensiopal_ssh_preproduction ;;
                production)             sensiopal_ssh_production ;;
                *)                      sensiopal_ssh ;;

            esac
        ;;
        *)
            sleep .2
            cd ~/SENSIOPAL;
            sensiopal_conf
            sleep .2
            sensiopal_list
            echo 
        ;;
    esac

} 

alias sd='sensiopal'

##
## Conf
##
sensiopal_conf()
{

    shout=""

    unset DEV_NAME
    unset DEV_EMAIL
    
    unset PROJECT_ID

    unset LINK_SMB
    unset LINK_DOCS
    unset LINK_GITHUB
    unset LINK_REDMINE

    unset GITHUB_USER
    unset GITHUB_REPO

    unset LOCAL_DOMAIN
    unset LOCAL_DP_USER
    unset LOCAL_DP_PASS
    unset LOCAL_DP_DB_PREFIX
    unset LOCAL_BRANCH

    unset STAGING_DOMAIN
    unset STAGING_DIR
    unset STAGING_SSH_USER
    unset STAGING_SSH_IP
    unset STAGING_SSH_PORT
    unset STAGING_DB_NAME
    unset STAGING_DB_PREFIX
    unset STAGING_DB_USER
    unset STAGING_DB_PASS
    unset STAGING_DB_HOST
    unset STAGING_DP_USER
    unset STAGING_DP_PASS
    unset STAGING_BRANCH

    unset PREPRODUCTION_DOMAIN
    unset PREPRODUCTION_DIR
    unset PREPRODUCTION_SSH_USER
    unset PREPRODUCTION_SSH_IP
    unset PREPRODUCTION_SSH_PORT
    unset PREPRODUCTION_DB_NAME
    unset PREPRODUCTION_DB_PREFIX
    unset PREPRODUCTION_DB_USER
    unset PREPRODUCTION_DB_PASS
    unset PREPRODUCTION_DB_HOST
    unset PREPRODUCTION_DP_USER
    unset PREPRODUCTION_DP_PASS
    unset PREPRODUCTION_BRANCH

    unset PRODUCTION_DOMAIN
    unset PRODUCTION_DIR
    unset PRODUCTION_SSH_USER
    unset PRODUCTION_SSH_IP
    unset PRODUCTION_SSH_PORT
    unset PRODUCTION_DB_NAME
    unset PRODUCTION_DB_PREFIX
    unset PRODUCTION_DB_USER
    unset PRODUCTION_DB_PASS
    unset PRODUCTION_DB_HOST
    unset PRODUCTION_DP_USER
    unset PRODUCTION_DP_PASS
    unset PRODUCTION_BRANCH

    unset prepross_starting

    DP_PLUGINS="n"

    DOCKER_MACHINE_DRIVER="virtualbox"
    SENSIOPAL_MACHINE="sensiopal"

    #DOCKER_MACHINE_DRIVER="vmwarefusion"
    #SENSIOPAL_MACHINE="sensiopal-vmware"
    

    if ! [ $PASS ] 
        then
            read -sp "Password: " PASS
            echo
    fi

    set -a
    [ -f $(pwd)/SENSIOPAL ] && . $(pwd)/SENSIOPAL
    set +a

    mkdir -p ~/SENSIOPAL

}

##
## Conf
##
sensiopal_check_script_version()
{

    echo -n "$(tput setaf 6)SENSIOPAL::CHECK:SCRIPT...$(tput setaf 7)"

    SENSIOPAL_SCRIPT_VERSION=0
    
    if [ -e $SCRIPT_DIR/version ] 
        then
            SENSIOPAL_SCRIPT_VERSION=$(cat $SCRIPT_DIR/version)

    fi

    SENSIOPAL_SCRIPT_VERSION_LATEST="$(curl -H "Authorization: token $GITHUB_TOKEN" -L curl --silent "https://api.github.com/repos/ExtremeSensio/SENSIOPAL/releases/latest" | sed -n 's/.*"tag_name": "\(.*\)",/\1/p')"
    
    if [ "$SENSIOPAL_SCRIPT_VERSION_LATEST" != "" ]
        then
            if [ $SENSIOPAL_SCRIPT_VERSION == $SENSIOPAL_SCRIPT_VERSION_LATEST ]
                then
                    echo -n " $(tput setaf 2)OK v.$SENSIOPAL_SCRIPT_VERSION$(tput setaf 7)"
                    echo
                else
                    echo -n " $(tput setaf 1)KO require v.$SENSIOPAL_SCRIPT_VERSION_LATEST$(tput setaf 7)"
                    echo
                    if [ $SENSIOPAL_SCRIPT_VERSION == 0 ]
                        then
                            SENSIOPAL_SCRIPT_VERSION_UPDATE="y"
                        else
                            read -p "$(tput setaf 2)Update require.$(tput setaf 7) Install v.$SENSIOPAL_SCRIPT_VERSION_LATEST ? (y/n): " SENSIOPAL_SCRIPT_VERSION_UPDATE
                    fi
                    if [ $SENSIOPAL_SCRIPT_VERSION_UPDATE == "y" ]
                        then
                            echo "$(tput setaf 6)Installing v.$SENSIOPAL_SCRIPT_VERSION_LATEST...$(tput setaf 7)"
                            mkdir $SCRIPT_DIR/.download
                            curl -H "Authorization: token $GITHUB_TOKEN" -L https://api.github.com/repos/ExtremeSensio/SENSIOPAL/tarball -o $SCRIPT_DIR/.download/update.tar.gz
                            tar -xvf $SCRIPT_DIR/.download/update.tar.gz -C $SCRIPT_DIR/.download
                            rm $SCRIPT_DIR/.download/update.tar.gz
                            mv $SCRIPT_DIR/.download/*/sensiopal.sh $SCRIPT_DIR
                            mv $SCRIPT_DIR/.download/*/includes $SCRIPT_DIR
                            rm -R $SCRIPT_DIR/.download
                            echo "$SENSIOPAL_SCRIPT_VERSION_LATEST" > $SCRIPT_DIR/version
                            sleep .5
                            echo "$(tput setaf 2)SENSIOPAL is updated to v.$SENSIOPAL_SCRIPT_VERSION_LATEST$(tput setaf 7)"
                            sleep .5
                            echo "$(tput setaf 2)Open new terminal to reload SCRIPT$(tput setaf 7)"
                        else
                            echo "$(tput setaf 1)SENSIOPAL not updated to v.$SENSIOPAL_SCRIPT_VERSION_LATEST$(tput setaf 7)"
                    fi
            fi
        else
        echo "$(tput setaf 1)ERROR$(tput setaf 7)"
        echo "$(tput setaf 1)SENSIOPAL cannot connect to github to check the latest version of the script. Try again later.$(tput setaf 7)"

    fi


}



##
## Help
##
sensiopal_help()
{
    echo
    echo "--help"
    echo
    echo "  $ sensiopal new                   - Create new drupal project"
    echo "  $ sensiopal up                    - Start drupal project locally"
    echo "  $ sensiopal down                  - Stop drupal project locally"
    echo "  $ sensiopal delete                - Create a new drupal project"
    echo "  $ sensiopal deploy staging        - Deploy current project to staging environement"
    echo "  $ sensiopal deploy preproduction  - Deploy current project to preproduction environement"
    echo "  $ sensiopal deploy production     - Deploy current project to production environement"
    echo
    echo "SENSIOPAL by Yannick Armspach"
    echo
}


##
## List
##
sensiopal_list()
{

    echo "$(tput setaf 6)SENSIOPAL::PROJECTS$(tput setaf 7)"

    unset options i
    while IFS= read -r -d $'\0' f; do
    options[i++]="$(basename $f)"
    done < <(find ~/SENSIOPAL -maxdepth 1 -type d -print0 )
    options[i++]="quit"

    PS3='Select projet id to start: '
    COLUMNS=1
    select opt in "${options[@]}"
    do
        case $opt in
            "quit")
                break
                ;;
            *) 
                cd ~/SENSIOPAL/$opt
                sensiopal_run
                break
                ;;
        esac
    done

}

##
## Open
##
function sensiopal_open()
{

    if [ -d ~/SENSIOPAL/$ARG2 ];
        then
            echo "$(tput setaf 6)SENSIOPAL::OPEN $(tput setaf 3)~/SENSIOPAL/$ARG2$(tput setaf 7)"
            cd ~/SENSIOPAL/$ARG2
        else
            echo "$(tput setaf 2)SENSIOPAL::OPEN - no project found$(tput setaf 7)"
    fi

}

##
## New
##
function sensiopal_new()
{

    cd ~/SENSIOPAL

    if [ $ARG2 ] && [ -d ~/SENSIOPAL/$ARG2 ]
        then
            echo "$(tput setaf 1)Project with the same name already exist.$(tput setaf 7)"
        else
            PROJECT_ID=$ARG2
            if [ -z $PROJECT_ID ]
                then
                    echo "$(tput setaf 1)Project require id.$(tput setaf 7)" 
                else
                    
                    sensiopal_config

                    mkdir $PROJECT_ID
                    cd $PROJECT_ID

                    sensiopal_create

            fi
    fi

}

##
## Config
##
function sensiopal_config()
{

    echo "$(tput setaf 6)SENSIOPAL::NEW - ~/SENSIOPAL/$PROJECT_ID Config$(tput setaf 7)"
            
    read -p "Developer Name (default ExtremeSensio): " DEV_NAME
    if [ -z $DEV_NAME ] 
        then 
            DEV_NAME="ExtremeSensio"
            echo "$(tput setaf 2)set$(tput setaf 7) Developer Name: $DEV_NAME"
    fi

    read -p "Developer Email (default $DEV_NAME@$PROJECT_ID.local): " DEV_EMAIL
    if [ -z $DEV_EMAIL ] 
        then
            DEV_EMAIL="$DEV_NAME@$PROJECT_ID.local"
            echo "$(tput setaf 2)set$(tput setaf 7) Developer Email: $DEV_EMAIL"
    fi

    
    echo "$(tput setaf 6)SENSIOPAL::NEW - Github Config$(tput setaf 7)"

    read -p "Github User (default $DEV_NAME): " GITHUB_USER
    if [ -z $GITHUB_USER ] 
        then
            GITHUB_USER="$DEV_NAME"
            echo "$(tput setaf 2)set$(tput setaf 7) Github User: $GITHUB_USER"
    fi

    read -p "Github Repo (default $PROJECT_ID): " GITHUB_REPO
    if [ -z $GITHUB_REPO ] 
        then
            GITHUB_REPO="$PROJECT_ID"
            echo "$(tput setaf 2)set$(tput setaf 7) Github Repo: $GITHUB_REPO"
    fi

    echo "$(tput setaf 6)SENSIOPAL::NEW - Local Config$(tput setaf 7)"

    read -p "Local Domain (default $PROJECT_ID.local): " LOCAL_DOMAIN
    if [ -z $LOCAL_DOMAIN ] 
        then
            LOCAL_DOMAIN="$PROJECT_ID.local"
            echo "$(tput setaf 2)set$(tput setaf 7) Local Domain: $LOCAL_DOMAIN"
    fi

    read -p "Drupal Username (default: admin): " LOCAL_DP_USER
    if [ -z $LOCAL_DP_USER ]
        then
            LOCAL_DP_USER="admin"
            echo "$(tput setaf 2)set$(tput setaf 7) Drupal Username: $LOCAL_DP_USER"
    fi

    read -p "Drupal Password (default: admin): " LOCAL_DP_PASS
    if [ -z $LOCAL_DP_PASS ]
        then
            LOCAL_DP_PASS="admin"
            echo "$(tput setaf 2)set$(tput setaf 7) Drupal Password: $LOCAL_DP_PASS"
    fi

    read -p "Drupal db prefix (default: wp_): " LOCAL_DP_DB_PREFIX
    if [ -z $LOCAL_DP_DB_PREFIX ]
        then
            LOCAL_DP_DB_PREFIX="wp_"
            echo "$(tput setaf 2)set$(tput setaf 7) Drupal db prefix: $LOCAL_DP_DB_PREFIX"
    fi

    read -p "Install default Drupal Plugins (y/n): " DP_PLUGINS
    if [ -z $DP_PLUGINS ]
        then
            DP_PLUGINS="n"
    fi

    read -p "Git Branch (default: origin/master): " LOCAL_BRANCH
    if [ -z $LOCAL_BRANCH ] 
        then
            LOCAL_BRANCH="origin/master"
            echo "$(tput setaf 2)set$(tput setaf 7) Git Branch: $LOCAL_BRANCH"
    fi


    echo "$(tput setaf 6)SENSIOPAL::NEW - Staging Config$(tput setaf 7)"

    read -p "Staging Domain: " STAGING_DOMAIN

    read -p "Staging Directory: " STAGING_DIR

    read -p "Staging SSH User: " STAGING_SSH_USER
    read -p "Staging SSH IP: " STAGING_SSH_IP
    read -p "Staging SSH PORT: " STAGING_SSH_PORT

    read -p "Staging DB Name: " STAGING_DB_NAME
    read -p "Staging DB Prefix: " STAGING_DB_PREFIX
    read -p "Staging DB User: " STAGING_DB_USER
    read -p "Staging DB Pass: " STAGING_DB_PASS
    read -p "Staging DB Host: " STAGING_DB_HOST

    read -p "Staging Drupal Password: " STAGING_DP_PASS

    read -p "Staging Git Branch (default: origin/staging): " STAGING_BRANCH
    if [ -z $STAGING_BRANCH ] 
        then
            STAGING_BRANCH="origin/staging"
            echo "$(tput setaf 2)set$(tput setaf 7) Staging Git Branch: $STAGING_BRANCH"
    fi


    echo "$(tput setaf 6)SENSIOPAL::NEW - Preproduction Config$(tput setaf 7)"

    read -p "Preproduction Domain: " PREPRODUCTION_DOMAIN

    read -p "Preproduction Directory: " PREPRODUCTION_DIR

    read -p "Preproduction SSH User: " PREPRODUCTION_SSH_USER
    read -p "Preproduction SSH IP: " PREPRODUCTION_SSH_IP
    read -p "Preproduction SSH PORT: " PREPRODUCTION_SSH_PORT

    read -p "Preproduction DB Name: " PREPRODUCTION_DB_NAME
    read -p "Preproduction DB Prefix: " PREPRODUCTION_DB_PREFIX
    read -p "Preproduction DB User: " PREPRODUCTION_DB_USER
    read -p "Preproduction DB Pass: " PREPRODUCTION_DB_PASS
    read -p "Preproduction DB Host: " PREPRODUCTION_DB_HOST

    read -p "Preproduction Drupal Password: " PREPRODUCTION_DP_PASS

    read -p "Preproduction Git Branch (default: origin/preproduction): " PREPRODUCTION_BRANCH
    if [ -z $PREPRODUCTION_BRANCH ] 
        then
            PREPRODUCTION_BRANCH="origin/preproduction"
            echo "$(tput setaf 2)set$(tput setaf 7) Preproduction Git Branch: $PREPRODUCTION_BRANCH"
    fi


    echo "$(tput setaf 6)SENSIOPAL::NEW - Production Config$(tput setaf 7)"

    read -p "Production Domain: " PRODUCTION_DOMAIN

    read -p "Production Directory: " PRODUCTION_DIR

    read -p "Production SSH User: " PRODUCTION_SSH_USER
    read -p "Production SSH IP: " PRODUCTION_SSH_IP
    read -p "Production SSH PORT: " PRODUCTION_SSH_PORT

    read -p "Production DB Name: " PRODUCTION_DB_NAME
    read -p "Production DB Prefix: " PRODUCTION_DB_PREFIX
    read -p "Production DB User: " PRODUCTION_DB_USER
    read -p "Production DB Pass: " PRODUCTION_DB_PASS
    read -p "Production DB Host: " PRODUCTION_DB_HOST

    read -p "Production Drupal Password: " PRODUCTION_DP_PASS

    read -p "Production Git Branch (default: origin/production): " PRODUCTION_BRANCH
    if [ -z $PRODUCTION_BRANCH ] 
        then
            PRODUCTION_BRANCH="origin/preproduction"
            echo "$(tput setaf 2)set$(tput setaf 7) Production Git Branch: $PRODUCTION_BRANCH"
    fi

}

##
## chmod
##
function sensiopal_build_chmod()
{
    
    echo "$(tput setaf 6)SENSIOPAL::BUILD - Set Rights$(tput setaf 7)"

#    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "chown -R www-data:www-data /var/www/html/wp-content/plugins/linotype" $shout
#    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "chmod -R 777 /var/www/html/wp-content/plugins/linotype" $shout

#    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "chown -R www-data:www-data /var/www/html/wp-content/linotype" $shout
#    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "chmod -R 777 /var/www/html/wp-content/linotype" $shout

}



##
## Ready
##
function sensiopal_ready()
{

    echo "$(tput setaf 6)SENSIOPAL::READY - Infos$(tput setaf 7)"
    
    echo "PROJECT:" 
    if [ $LINK_SMB ] 
        then
            echo "$(tput setaf 3) smb     -> $(tput setaf 2)$LINK_SMB$(tput setaf 7)"
    fi
    if [ $LINK_DOCS ] 
        then
            echo "$(tput setaf 3) docs    -> $(tput setaf 2)$LINK_DOCS$(tput setaf 7)"
    fi
    if [ $LINK_GITHUB ] 
        then
            echo "$(tput setaf 3) github  -> $(tput setaf 2)$LINK_GITHUB$(tput setaf 7)"
    fi
    if [ $LINK_REDMINE ] 
        then
            echo "$(tput setaf 3) redmine -> $(tput setaf 2)$LINK_REDMINE$(tput setaf 7)"
    fi

    if [ $LOCAL_DOMAIN ] 
        then
            echo "LOCAL:" 
            echo "$(tput setaf 3) front -> $(tput setaf 2)https://$LOCAL_DOMAIN$(tput setaf 7)"
            echo "$(tput setaf 3) admin -> $(tput setaf 2)https://$LOCAL_DOMAIN/admin$(tput setaf 7)"
        else
            echo "LOCAL:"
            echo "$(tput setaf 1) null$(tput setaf 7)"
    fi
    if [ $STAGING_DOMAIN ] 
        then
            echo "STAGING:" 
            echo "$(tput setaf 3) front -> $(tput setaf 2)https://$STAGING_DOMAIN$(tput setaf 7)"
            echo "$(tput setaf 3) admin -> $(tput setaf 2)https://$STAGING_DOMAIN/admin$(tput setaf 7)"
        else
            echo "STAGING:"
            echo "$(tput setaf 1) null$(tput setaf 7)"
    fi
    if [ $PREPRODUCTION_DOMAIN ] 
        then
            echo "PREPRODUCTION:" 
            echo "$(tput setaf 3) front -> $(tput setaf 2)https://$PREPRODUCTION_DOMAIN$(tput setaf 7)"
            echo "$(tput setaf 3) admin -> $(tput setaf 2)https://$PREPRODUCTION_DOMAIN/admin$(tput setaf 7)"
        else
            echo "PREPRODUCTION:"
            echo "$(tput setaf 1) null$(tput setaf 7)"
    fi
    if [ $PRODUCTION_DOMAIN ] 
        then
            echo "PRODUCTION:" 
            echo "$(tput setaf 3) front -> $(tput setaf 2)https://$PRODUCTION_DOMAIN$(tput setaf 7)"
            echo "$(tput setaf 3) admin -> $(tput setaf 2)https://$PRODUCTION_DOMAIN/admin$(tput setaf 7)"
        else
            echo "PRODUCTION:"
            echo "$(tput setaf 1) null$(tput setaf 7)"
    fi

    # read -p "Start prepross watch (y/n): " prepross_starting
    # if [ $prepross_starting == "y" ] 
    #     then
    #         sensiopal_watch
    # fi
    
    
}


##
## Down
##
function sensiopal_down()
{

    echo "$(tput setaf 6)SENSIOPAL::DOWN$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e local/config.yml ] 
        then
            docker-compose -f local/config.yml down --remove-orphans $shout
            docker stop $(docker ps -a -q) $shout
            echo $PASS | sudo -S sed -i '' "/#SENSIOPAL/d" /etc/hosts $shout

        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - no project found$(tput setaf 7)"
    fi

    read -p "Stop sensiopal machine (y/n): " sensiopal_down_machine
    if [ $sensiopal_down_machine == "y" ]
        then
            docker-machine stop $SENSIOPAL_MACHINE $shout
    fi

}


##
## Kill
##
function sensiopal_kill()
{

    echo "$(tput setaf 6)SENSIOPAL::KILL$(tput setaf 7)"

    echo $PASS | sudo -S sed -i '' "/#SENSIOPAL/d" /etc/hosts $shout

    read -p "Stop all container (y/n): " sensiopal_stop_container
    if [ $sensiopal_stop_container == "y" ]
        then
            docker container stop $(docker container ls -aq) $shout
    fi
    
    read -p "Delete all container (y/n): " sensiopal_kill_container
    if [ $sensiopal_kill_container == "y" ]
        then
            docker rm $(docker ps -a -q) $shout
    fi

    read -p "Delete all images (y/n): " sensiopal_kill_images
    if [ $sensiopal_kill_images == "y" ]
        then
            docker rmi -f $(docker images -q) $shout
    fi
    
    read -p "Stop sensiopal machine (y/n): " sensiopal_kill_machine
    if [ $sensiopal_kill_machine == "y" ]
        then
            docker-machine stop $SENSIOPAL_MACHINE $shout
    fi

}


##
## Delete
##
function sensiopal_delete()
{

    echo "$(tput setaf 6)SENSIOPAL::DELETE$(tput setaf 7)"

    echo $PASS | sudo -S sed -i '' "/#SENSIOPAL/d" /etc/hosts $shout

    read -p "Delete all $PROJECT_ID container (y/n): " sensiopal_delete_container
    if [ $sensiopal_delete_container == "y" ]
        then
            docker rm -f $(docker ps -a -q --filter="name=$PROJECT_ID-webserver") $shout
            docker rm -f $(docker ps -a -q --filter="name=$PROJECT_ID-mysql") $shout
            docker rm -f $(docker ps -a -q --filter="name=$PROJECT_ID-phpmyadmin") $shout
            docker rm -f $(docker ps -a -q --filter="name=$PROJECT_ID-redis") $shout
    fi

    read -p "Delete all $PROJECT_ID images (y/n): " sensiopal_delete_images
    if [ $sensiopal_delete_images == "y" ]
        then
            docker rm -f $(docker images -f "name=$PROJECT_ID-webserver" -q) $shout
            docker rm -f $(docker images -f "name=$PROJECT_ID-mysql" -q) $shout
            docker rm -f $(docker images -f "name=$PROJECT_ID-phpmyadmin" -q) $shout
            docker rm -f $(docker images -f "name=$PROJECT_ID-redis" -q) $shout
    fi

    read -p "Delete all unlink images (y/n): " sensiopal_delete_images
    if [ $sensiopal_delete_images == "y" ]
        then
            docker image rm -f $(docker images -f "dangling=true" -q) $shout
    fi
    
    read -p "Stop sensiopal machine (y/n): " sensiopal_delete_machine
    if [ $sensiopal_delete_machine == "y" ]
        then
            docker-machine stop $SENSIOPAL_MACHINE $shout
    fi

}


##
## Logs
##
function sensiopal_logs()
{

    echo "$(tput setaf 6)SENSIOPAL::LOGS$(tput setaf 7)"

    docker-compose -f local/config.yml logs

}


##
## SSH
##
function sensiopal_ssh()
{

    echo "$(tput setaf 6)SENSIOPAL::CONNECT$(tput setaf 7)"

    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE bash

}

##
## Install
##
function sensiopal_install()
{
    
    cd ~/SENSIOPAL

    ID="$(cut -d'/' -f2 <<<"$ARG2")"

    if [ $ID ] 
        then

            if [ -d ~/SENSIOPAL/$ID ]
                then
                    echo "$(tput setaf 1)Project with the same name already exist $(tput setaf 7)"
                else

                    if [ $ARG2 ]
                        then
                            git clone git@github.com:$ARG2.git
                            cd ~/SENSIOPAL/$ID
                            sensiopal_up
                        else
                            echo "$(tput setaf 1)No project $ARG2 founded $(tput setaf 7)"
                    fi
                    
            fi

        else
            echo "$(tput setaf 1)Project github path is require. e.g. username/repo $(tput setaf 7)"
        
    fi

}

##
## Create
##
function sensiopal_create()
{

    sensiopal_create_step__directories

    sensiopal_create_step__sensiopal
    
    sensiopal_create_step__docs

    sensiopal_create_step__docker_compose
    sensiopal_create_step__dockerfile_webserver
    sensiopal_create_step__dockerfile_mysql
    
    sensiopal_create_step__npm_package
    sensiopal_create_step__npm_gulpfile

    sensiopal_create_step__php_ini
    sensiopal_create_step__cert
    sensiopal_create_step__vhost
    sensiopal_create_step__ssh

    sensiopal_create_step__readme
    sensiopal_create_step__readme_local
    sensiopal_create_step__gitignore
    sensiopal_create_step__git

    sensiopal_create_step__deployer
    sensiopal_create_step__deployer_sync

    sensiopal_create_step__dp_config

    sensiopal_up_docker

    sensiopal_build

    sensiopal_build_chmod

    sensiopal_ready

}

##
## Init
##
function sensiopal_init()
{

    sensiopal_create_step__directories

    sensiopal_create_step__sensiopal
    
    sensiopal_create_step__docs

    sensiopal_create_step__docker_compose
    sensiopal_create_step__dockerfile_webserver
    sensiopal_create_step__dockerfile_mysql
    
    sensiopal_create_step__npm_package
    sensiopal_create_step__npm_gulpfile

    sensiopal_create_step__php_ini
    sensiopal_create_step__cert
    sensiopal_create_step__vhost
    sensiopal_create_step__ssh

    sensiopal_create_step__readme
    sensiopal_create_step__readme_local
    sensiopal_create_step__gitignore
    sensiopal_create_step__git

    sensiopal_create_step__deployer
    sensiopal_create_step__deployer_sync

    sensiopal_create_step__dp_config

    sensiopal_up_docker
    
    sensiopal_ready

}


##
## Up : start docker, docker-machine, add hosts
##
function sensiopal_up()
{

    if [ $ARG2 ] && [ -d ~/SENSIOPAL/$ARG2 ]
        then
        cd ~/SENSIOPAL/$ARG2
    fi

    sensiopal_run

}

##
## Up : start docker, docker-machine, add hosts
##
function sensiopal_run()
{

    sensiopal_conf
    
    if [ $PROJECT_ID ] && [ -e local/config.yml ] 
        then
            

            if [ -z "$SENSIOPAL_VERSION" ] || [ $SENSIOPAL_VERSION != $SENSIOPAL_SCRIPT_VERSION ]
                then
                    echo "$(tput setaf 6)SENSIOPAL::CHECK project... $(tput setaf 1)KO$(tput setaf 7)"
                    echo "$(tput setaf 1)Your project '$PROJECT_ID' is not up to date. You can update it.$(tput setaf 7)"
                    echo "$(tput setaf 7)If you want you can upgrade this project with $(tput setaf 6)sd init$(tput setaf 7) or just use in current version$(tput setaf 7)"
                    read -p "Start '$PROJECT_ID' anyway? (y/n): " sensiopal_no_update
                    if [ $sensiopal_no_update == "y" ]
                        then
                        echo "$(tput setaf 6)SENSIOPAL::CHECK project... $(tput setaf 2)OK$(tput setaf 7)"
                    
                        sensiopal_up_docker

                        git config core.filemode false
                    
                        sensiopal_validate_cert

                        sensiopal_ready

                    fi
                    
                else
                    echo "$(tput setaf 6)SENSIOPAL::CHECK project... $(tput setaf 2)OK$(tput setaf 7)"
                    
                    sensiopal_up_docker

                    git config core.filemode false
                    
                    sensiopal_validate_cert

                    sensiopal_ready
            fi

        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}

function sensiopal_watch()
{

    echo "$(tput setaf 6)SENSIOPAL::NPM - sass watch$(tput setaf 7)"
    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "/root/npm/node_modules/gulp/bin/gulp.js --gulpfile /root/npm/gulpfile.js --cwd /var/www/html" $shout

}

function sensiopal_up_docker()
{

    if [ $ARG2 ] && [ -d ~/SENSIOPAL/$ARG2 ]
        then
        cd ~/SENSIOPAL/$ARG2
    fi

    sensiopal_conf
    
    if [ $PROJECT_ID ] && [ -e local/config.yml ] 
        then
            echo "$(tput setaf 6)SENSIOPAL::UP - Start Docker$(tput setaf 7)"
            docker start $shout

            echo "$(tput setaf 6)SENSIOPAL::UP - Start Docker Machine$(tput setaf 7)"
            docker-machine create --driver $DOCKER_MACHINE_DRIVER $SENSIOPAL_MACHINE $shout
            docker-machine start $SENSIOPAL_MACHINE $shout
            docker-machine env $SENSIOPAL_MACHINE $shout
            eval $(docker-machine env $SENSIOPAL_MACHINE)
            
            echo "$(tput setaf 6)SENSIOPAL::UP - Build Docker$(tput setaf 7)"
            docker-compose -f local/config.yml up -d --build --remove-orphans $shout 

            echo "$(tput setaf 6)SENSIOPAL::UP - Set Hosts$(tput setaf 7)"
            echo $PASS | sudo -S sed -i '' "/#SENSIOPAL/d" /etc/hosts $shout
            echo $PASS | sudo -- sh -c -e "echo '$(docker-machine ip $SENSIOPAL_MACHINE) $LOCAL_DOMAIN #SENSIOPAL' >> /etc/hosts" $shout
            echo $PASS | sudo -- sh -c -e "echo '$(docker-machine ip $SENSIOPAL_MACHINE) en.$LOCAL_DOMAIN #SENSIOPAL' >> /etc/hosts" $shout
            echo
            
        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}



##
## Build
##
function sensiopal_build()
{

    if [ $PROJECT_ID ] 
        then
            echo "$(tput setaf 6)SENSIOPAL::BUILD - Drupal core$(tput setaf 7)"

            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "composer create-project drupal-composer/drupal-project:8.x-dev --prefer-dist --no-progress --no-interaction" $shout
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal site:install standard --db-host=db_$PROJECT_ID --db-port=3306 --db-name=db_$PROJECT_ID --db-prefix=$LOCAL_DP_DB_PREFIX --db-user=root --db-pass=root --account-name=$LOCAL_DP_USER --account-pass=$LOCAL_DP_PASS --site-mail=$DEV_EMAIL --site-name=$PROJECT_ID --no-interaction --force" $shout

            # TODO: Add code to create a default custom Drupal theme.

#            mkdir -p public/web/themes/blank
#            echo "<?php" > public/web/themes/blank/index.php

            sensiopal_build_wp
            
        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}

##
## Drupal
##
function sensiopal_build_wp()
{

    if [ $PROJECT_ID ] 
        then
            echo "$(tput setaf 6)SENSIOPAL::BUILD - Drupal Plugins$(tput setaf 7)"

            if [ $DP_PLUGINS == "y" ]
                then
                    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal module:install drush admin_toolbar entity_browser entity_reference_revisions entity_usage field_group linkit paragraphs conditional_fields crop image_widget_crop --composer" $shout
            fi

            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal module:install drush --composer" $shout

        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}


##
## Database import
##
function sensiopal_db_local_import()
{

    echo "$(tput setaf 6)SENSIOPAL::DB - Import$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/db/local.sql ]
        then
            echo "$(tput setaf 6)SENSIOPAL::DB - Prepare drupal$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - Importing$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal database:restore --file=/var/www/db/local.sql" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - clean new db$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No db to import founded ~/SENSIOPAL/$PROJECT_ID/local/db/local.sql$(tput setaf 7)"
    fi
}
function sensiopal_db_local_import_staging()
{

    echo "$(tput setaf 6)SENSIOPAL::DB - Import$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/db/staging.sql ]
        then
            echo "$(tput setaf 6)SENSIOPAL::DB - Prepare drupal$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - Importing$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal database:restore --file=/var/www/db/staging.sql" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - clean new db$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No db to import founded ~/SENSIOPAL/$PROJECT_ID/local/db/staging.sql$(tput setaf 7)"
    fi
}
function sensiopal_db_local_import_preproduction()
{

    echo "$(tput setaf 6)SENSIOPAL::DB - Import$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/db/preproduction.sql ]
        then
            echo "$(tput setaf 6)SENSIOPAL::DB - Prepare drupal$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - Importing$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal database:restore --file=/var/www/db/preproduction.sql" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - clean new db$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No db to import founded ~/SENSIOPAL/$PROJECT_ID/local/db/preproduction.sql$(tput setaf 7)"
    fi
}
function sensiopal_db_local_import_production()
{

    echo "$(tput setaf 6)SENSIOPAL::DB - Import$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/db/production.sql ]
        then
            echo "$(tput setaf 6)SENSIOPAL::DB - Prepare drupal$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - Importing$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal database:restore --file=/var/www/db/production.sql" $shout
            echo "$(tput setaf 6)SENSIOPAL::DB - clean new db$(tput setaf 7)"
            docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal cache:rebuild" $shout
        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No db to import founded ~/SENSIOPAL/$PROJECT_ID/local/db/production.sql$(tput setaf 7)"
    fi
}


##
## Database export
##
function sensiopal_db_local_export()
{

    echo "$(tput setaf 6)SENSIOPAL::DB - Export$(tput setaf 7)"

    docker-compose -f local/config.yml exec $SENSIOPAL_MACHINE sh -c "vendor/bin/drupal database:dump --file=/var/www/db/local.sql" $shout

}

##
## Sync
##
function sensiopal_sync_to()
{

    echo "$(tput setaf 6)SENSIOPAL::SYNC - from local to $ARG3$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-to-staging.php ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-to-preproduction.php ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-to-production.php ]
        then

            sensiopal_db_local_export
                        
            case $ARG3 in

                staging)                sed "s/$LOCAL_DOMAIN/$STAGING_DOMAIN/g" local/db/local.sql > local/db/staging.dist.sql
                                        dep -f=local/dep/sync-to-staging.php sync -vvv ;;

                preproduction)          sed "s/$LOCAL_DOMAIN/$PREPRODUCTION_DOMAIN/g" local/db/local.sql > local/db/preproduction.dist.sql
                                        dep -f=local/dep/sync-to-preproduction.php sync -vvv ;;

                production)             sed "s/$LOCAL_DOMAIN/$PRODUCTION_DOMAIN/g" local/db/local.sql > local/db/production.dist.sql
                                        dep -f=local/dep/sync-to-production.php sync -vvv ;;

                *)                      sensiopal_help ;;
            esac
            
            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}
function sensiopal_sync_from()
{

    echo "$(tput setaf 6)SENSIOPAL::SYNC - from $ARG3 to local$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-from-staging.php ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-from-preproduction.php ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/sync-from-production.php ]
        then
            
            case $ARG3 in

                staging)                dep -f=local/dep/sync-from-staging.php sync -vvv 
                                        sensiopal_db_local_import_staging ;;

                preproduction)          dep -f=local/dep/sync-from-preproduction.php sync -vvv 
                                        sensiopal_db_local_import_preproduction ;;

                production)             dep -f=local/dep/sync-from-production.php sync -vvv 
                                        sensiopal_db_local_import_production ;;

                *)                      sensiopal_help ;;
            esac
            
            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}

##
## Deploy Github
##
function sensiopal_deploy_github()
{

    if [ $PROJECT_ID ] 
        then
            echo "$(tput setaf 6)SENSIOPAL::INIT - Create repo $GITHUB_USER/$GITHUB_REPO Create $(tput setaf 7)"
            hub create --private --description "" --homepage "" --remote-name "origin" $GITHUB_USER/$GITHUB_REPO $shout
            git add . && git commit -m "SENSIOPAL::init" $shout
            git push -u origin master $shout

            sensiopal_ready

        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}

##
## Deploy Staging
##
function sensiopal_deploy_staging()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY - staging$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-staging.php ]
        then
            
            dep -f=local/dep/deploy-staging.php deploy -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}
function sensiopal_deploy_staging_rights()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:RIGHTS - staging$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-staging.php ]
        then
            
            dep -f=local/dep/deploy-staging.php deploy:rights -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}
function sensiopal_rollback_staging()
{

    echo "$(tput setaf 6)SENSIOPAL::ROLLBACK - staging$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-staging.php ]
        then
            
            dep -f=local/dep/deploy-staging.php rollback -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}
function sensiopal_ssh_staging()
{

    echo "$(tput setaf 6)SENSIOPAL::SSH - staging$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-staging.php ]
        then
            
            dep -f=local/dep/deploy-staging.php ssh -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi

}

##
## Deploy preproduction
##
function sensiopal_deploy_preproduction()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-preproduction.php ]
        then
            
            dep -f=local/dep/deploy-preproduction.php deploy -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_deploy_preproduction_rights()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:RIGHTS - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-preproduction.php ]
        then
            
            dep -f=local/dep/deploy-preproduction.php deploy:rights -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_rollback_preproduction()
{

    echo "$(tput setaf 6)SENSIOPAL::ROLLBACK - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-preproduction.php ]
        then
            
            dep -f=local/dep/deploy-preproduction.php rollback -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_ssh_preproduction()
{

    echo "$(tput setaf 6)SENSIOPAL::SSH - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-preproduction.php ]
        then
            
            dep -f=local/dep/deploy-preproduction.php ssh -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}

##
## Deploy Production
##
function sensiopal_deploy_production()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY - production$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-production.php ]
        then
            
            dep -f=local/dep/deploy-production.php deploy -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_deploy_production_rights()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:RIGHTS - production$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-production.php ]
        then
            
            dep -f=local/dep/deploy-production.php deploy:rights -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_rollback_production()
{

    echo "$(tput setaf 6)SENSIOPAL::ROLLBACK - production$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-production.php ]
        then
            
            dep -f=local/dep/deploy-production.php rollback -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}
function sensiopal_ssh_production()
{

    echo "$(tput setaf 6)SENSIOPAL::SSH - production$(tput setaf 7)"

    if [ $PROJECT_ID ] && [ -e ~/SENSIOPAL/$PROJECT_ID/local/dep/deploy-production.php ]
        then
            
            dep -f=local/dep/deploy-production.php ssh -vvv

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No deploy script found$(tput setaf 7)"
    fi
    
}

##
## SFTP Staging
##
function sensiopal_deploy_sftp_staging()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:SFTP - staging$(tput setaf 7)"

    if [ $PROJECT_ID ] 
        then
            
            echo "put -r public/wp-content
            put -r app/blocks wp-content/linotype
            put -r app/fields wp-content/linotype
            put -r app/libraries wp-content/linotype
            put -r app/modules wp-content/linotype
            put -r app/templates wp-content/linotype
            put -r app/themes wp-content/linotype
            put -r public/wp-admin
            put -r public/wp-includes
            put -r public/wp-includes
            put -r public/.htaccess
            put -r public/index.php
            put -r public/wp-activate.php
            put -r public/wp-blog-header.php
            put -r public/wp-comments-post.php
            put -r public/wp-cron.php
            put -r public/wp-links-opml.php
            put -r public/wp-load.php
            put -r public/wp-login.php
            put -r public/wp-mail.php
            put -r public/wp-settings.php
            put -r public/wp-signup.php
            put -r public/wp-trackback.php
            put -r public/xmlrpc.php
            put -r local/dp/dp-config.staging.php
            rename wp-config.staging.php wp-config.php" | sftp 1682386@sftp.sd3.gpaas.net:/lamp0/web/vhosts/55073af37ea34f71b67511314eeb4ec8.yatu.ws/htdocs

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - sftp error$(tput setaf 7)"
    fi

}

##
## SFTP Staging
##
function sensiopal_deploy_sftp_preproduction()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:SFTP - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] 
        then
            
            echo "put -r public/wp-content
            put -r app/blocks wp-content/linotype
            put -r app/fields wp-content/linotype
            put -r app/libraries wp-content/linotype
            put -r app/modules wp-content/linotype
            put -r app/templates wp-content/linotype
            put -r app/themes wp-content/linotype
            put -r public/wp-admin
            put -r public/wp-includes
            put -r public/wp-includes
            put -r public/.htaccess
            put -r public/index.php
            put -r public/wp-activate.php
            put -r public/wp-blog-header.php
            put -r public/wp-comments-post.php
            put -r public/wp-cron.php
            put -r public/wp-links-opml.php
            put -r public/wp-load.php
            put -r public/wp-login.php
            put -r public/wp-mail.php
            put -r public/wp-settings.php
            put -r public/wp-signup.php
            put -r public/wp-trackback.php
            put -r public/xmlrpc.php
            put -r local/dp/dp-config.preproduction.php
            rename wp-config.preproduction.php wp-config.php" | sftp 1682386@sftp.sd3.gpaas.net:/lamp0/web/vhosts/55073af37ea34f71b67511314eeb4ec8.yatu.ws/htdocs

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - sftp error$(tput setaf 7)"
    fi

}

function sensiopal_deploy_sftp_preproduction_update()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:SFTP - preproduction$(tput setaf 7)"

    if [ $PROJECT_ID ] 
        then
            
            echo "put -r public/wp-content/uploads wp-content
            put -r app/blocks wp-content/linotype
            put -r app/fields wp-content/linotype
            put -r app/libraries wp-content/linotype
            put -r app/modules wp-content/linotype
            put -r app/templates wp-content/linotype
            put -r app/themes wp-content/linotype
            " | sftp 1682386@sftp.sd3.gpaas.net:/lamp0/web/vhosts/55073af37ea34f71b67511314eeb4ec8.yatu.ws/htdocs

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - sftp error$(tput setaf 7)"
    fi

}

##
## SFTP Staging
##
function sensiopal_deploy_sftp_production()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:SFTP - production$(tput setaf 7)"

    if [ $PROJECT_ID ] 
        then
            
            echo "
            put -r public/wp-content
            put -r app/blocks wp-content/linotype
            put -r app/fields wp-content/linotype
            put -r app/libraries wp-content/linotype
            put -r app/modules wp-content/linotype
            put -r app/templates wp-content/linotype
            put -r app/themes wp-content/linotype
            put -r public/wp-admin
            put -r public/wp-includes
            put -r public/wp-includes
            put -r public/.htaccess
            put -r public/index.php
            put -r public/wp-activate.php
            put -r public/wp-blog-header.php
            put -r public/wp-comments-post.php
            put -r public/wp-cron.php
            put -r public/wp-links-opml.php
            put -r public/wp-load.php
            put -r public/wp-login.php
            put -r public/wp-mail.php
            put -r public/wp-settings.php
            put -r public/wp-signup.php
            put -r public/wp-trackback.php
            put -r public/xmlrpc.php
            put -r local/dp/dp-config.production.php
            rename wp-config.production.php wp-config.php
            " | sftp 1682386@sftp.sd3.gpaas.net:/lamp0/web/vhosts/128db.fr/htdocs

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - sftp error$(tput setaf 7)"
    fi

}

function sensiopal_deploy_sftp_production_update()
{

    echo "$(tput setaf 6)SENSIOPAL::DEPLOY:SFTP - production$(tput setaf 7)"

    if [ $PROJECT_ID ] 
        then
            
            echo "put -r app/blocks wp-content/linotype
            put -r app/fields wp-content/linotype
            put -r app/libraries wp-content/linotype
            put -r app/modules wp-content/linotype
            put -r app/templates wp-content/linotype
            put -r app/themes wp-content/linotype
            " | sftp 1682386@sftp.sd3.gpaas.net:/lamp0/web/vhosts/128db.fr/htdocs

            sensiopal_ready

        else
            echo "$(tput setaf 1)SENSIOPAL::ERROR - sftp error$(tput setaf 7)"
    fi

}

#git init
function sensiopal_create_step__git()
{

    if [ $PROJECT_ID ] 
        then
            if [ -d $(pwd)/.git ]; 
                then
                    echo "$(tput setaf 2)SENSIOPAL::INIT - Project already exist in github$(tput setaf 7)"
                else
                    echo "$(tput setaf 6)SENSIOPAL::INIT - Create repo $GITHUB_USER/$GITHUB_REPO Create $(tput setaf 7)"
                    hub init $shout
                    git config core.filemode false
                    git config user.name "$DEV_NAME"
                    git config user.email "$DEV_EMAIL"
            fi
        else 
            echo "$(tput setaf 1)SENSIOPAL::ERROR - No project found$(tput setaf 7)"
    fi

}

############################################################
### Create Steps ##########################################
############################################################

#Create directory structure
function sensiopal_create_step__directories()
{
        
    echo "$(tput setaf 6)SENSIOPAL::INIT - Create directory structure$(tput setaf 7)"
    
    mkdir -p app

    mkdir -p doc
    
    mkdir -p local/bin/mysql
    mkdir -p local/bin/webserver

    mkdir -p local/dep
    mkdir -p local/php
    mkdir -p local/npm
    mkdir -p local/ssl
    mkdir -p local/conf
    mkdir -p local/ssh
    mkdir -p local/dp

    mkdir -p logs/php
    mkdir -p logs/apache
    mkdir -p logs/mysql

    mkdir -p public

}

#new env
function sensiopal_create_step__sensiopal()
{

    if [ -z $LINK_SMB ] 
        then
            LINK_SMB="smb://172.16.6.252/SENSIO/Production/$PROJECT_ID"
    fi

    if [ -z $LINK_GITHUB ] 
        then
            LINK_GITHUB="https://github.com/$GITHUB_USER/$GITHUB_REPO"
    fi

    if [ -z $LINK_REDMINE ] 
        then
            LINK_REDMINE="https://sensiogrey.easyredmine.com/projects/$LINK_REDMINE"
    fi

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create sensiopal config$(tput setaf 7)"
    cat <<EOF >SENSIOPAL
SENSIOPAL_VERSION=$SENSIOPAL_SCRIPT_VERSION

DEV_NAME=$DEV_NAME
DEV_EMAIL=$DEV_EMAIL

PROJECT_ID=$PROJECT_ID

LINK_SMB=$LINK_SMB
LINK_GITHUB=$LINK_GITHUB
LINK_REDMINE=$LINK_REDMINE

GITHUB_USER=$GITHUB_USER
GITHUB_REPO=$GITHUB_REPO

LOCAL_DOMAIN=$LOCAL_DOMAIN
LOCAL_DP_USER=$LOCAL_DP_USER
LOCAL_DP_PASS=$LOCAL_DP_PASS
LOCAL_DP_DB_PREFIX=$LOCAL_DP_DB_PREFIX
LOCAL_BRANCH=$LOCAL_BRANCH

STAGING_DOMAIN=$STAGING_DOMAIN
STAGING_DIR=$STAGING_DIR
STAGING_SSH_USER=$STAGING_SSH_USER
STAGING_SSH_IP=$STAGING_SSH_IP
STAGING_SSH_PORT=$STAGING_SSH_PORT
STAGING_DB_NAME=$STAGING_DB_NAME
STAGING_DB_PREFIX=$STAGING_DB_PREFIX
STAGING_DB_USER=$STAGING_DB_USER
STAGING_DB_PASS=$STAGING_DB_PASS
STAGING_DB_HOST=$STAGING_DB_HOST
STAGING_DP_USER=$LOCAL_DP_USER
STAGING_DP_PASS=$STAGING_DP_PASS
STAGING_BRANCH=$STAGING_BRANCH

PREPRODUCTION_DOMAIN=$PREPRODUCTION_DOMAIN
PREPRODUCTION_DIR=$PREPRODUCTION_DIR
PREPRODUCTION_SSH_USER=$PREPRODUCTION_SSH_USER
PREPRODUCTION_SSH_IP=$PREPRODUCTION_SSH_IP
PREPRODUCTION_SSH_PORT=$PREPRODUCTION_SSH_PORT
PREPRODUCTION_DB_NAME=$PREPRODUCTION_DB_NAME
PREPRODUCTION_DB_PREFIX=$PREPRODUCTION_DB_PREFIX
PREPRODUCTION_DB_USER=$PREPRODUCTION_DB_USER
PREPRODUCTION_DB_PASS=$PREPRODUCTION_DB_PASS
PREPRODUCTION_DB_HOST=$PREPRODUCTION_DB_HOST
PREPRODUCTION_DP_USER=$LOCAL_DP_USER
PREPRODUCTION_DP_PASS=$PREPRODUCTION_DP_PASS
PREPRODUCTION_BRANCH=$PREPRODUCTION_BRANCH

PRODUCTION_DOMAIN=$PRODUCTION_DOMAIN
PRODUCTION_DIR=$PRODUCTION_DIR
PRODUCTION_SSH_USER=$PRODUCTION_SSH_USER
PRODUCTION_SSH_IP=$PRODUCTION_SSH_IP
PRODUCTION_SSH_PORT=$PRODUCTION_SSH_PORT
PRODUCTION_DB_NAME=$PRODUCTION_DB_NAME
PRODUCTION_DB_PREFIX=$PRODUCTION_DB_PREFIX
PRODUCTION_DB_USER=$PRODUCTION_DB_USER
PRODUCTION_DB_PASS=$PRODUCTION_DB_PASS
PRODUCTION_DB_HOST=$PRODUCTION_DB_HOST
PRODUCTION_DP_USER=$LOCAL_DP_USER
PRODUCTION_DP_PASS=$PRODUCTION_DP_PASS
PRODUCTION_BRANCH=$PRODUCTION_BRANCH
EOF

}

#new index
function sensiopal_create_step__gitignore()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create gitignore$(tput setaf 7)"
    sed "
    s/VAR_LOCAL/local/g
    " $SCRIPT_PATH/includes/templates/gitignore > .gitignore

}

#new README
function sensiopal_create_step__readme()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create README$(tput setaf 7)"
    sed "
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    s/VAR_GITHUB_REPO/$GITHUB_REPO/g
    s/VAR_GITHUB_USER/$GITHUB_USER/g
    " $SCRIPT_PATH/includes/templates/README.md > README.md

}

#new README
function sensiopal_create_step__readme_local()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create README local$(tput setaf 7)"
    sed "
    s/VAR_LOCAL_DOMAIN/$LOCAL_DOMAIN/g
    " $SCRIPT_PATH/includes/templates/local/local.md > local/local.md

}

#new README
function sensiopal_create_step__dp_config()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create Drupal staging config$(tput setaf 7)"
    sed "
    s/VAR_FILE/staging/g
    s/VAR_DB_NAME/$STAGING_DB_NAME/g
    s/VAR_DB_USER/$STAGING_DB_USER/g
    s/VAR_DB_PASS/$STAGING_DB_PASS/g
    s/VAR_DB_HOST/$STAGING_DB_HOST/g
    s/VAR_DB_PREFIX/$STAGING_DB_PREFIX/g
    s/VAR_SALT/fdrstaghdofiudtsregbcgdfrstekgfh/g
    s/VAR_DEBUG/true/g
    " $SCRIPT_PATH/includes/templates/local/dp/dp-config.php > local/dp/dp-config.staging.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create Drupal preproduction config$(tput setaf 7)"
    sed "
    s/VAR_FILE/preproduction/g
    s/VAR_DB_NAME/$PREPRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PREPRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PREPRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PREPRODUCTION_DB_HOST/g
    s/VAR_DB_PREFIX/$PREPRODUCTION_DB_PREFIX/g
    s/VAR_SALT/fdrstaghdofiudtsregbcgdfrstekgfh/g
    s/VAR_DEBUG/false/g
    " $SCRIPT_PATH/includes/templates/local/dp/dp-config.php > local/dp/dp-config.preproduction.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create Drupal production config$(tput setaf 7)"
    sed "
    s/VAR_FILE/production/g
    s/VAR_DB_NAME/$PRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PRODUCTION_DB_HOST/g
    s/VAR_DB_PREFIX/$PRODUCTION_DB_PREFIX/g
    s/VAR_SALT/fdrstaghdofiudtsregbcgdfrstekgfh/g
    s/VAR_DEBUG/false/g
    " $SCRIPT_PATH/includes/templates/local/dp/dp-config.php > local/dp/dp-config.production.php

}

#new docker-compose
function sensiopal_create_step__deployer()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer staging$(tput setaf 7)"
    sed "
    s/VAR_FILE/staging/g
    s/VAR_SSH_IP/$STAGING_SSH_IP/g
    s/VAR_SSH_PORT/$STAGING_SSH_PORT/g
    s/VAR_SSH_USER/$STAGING_SSH_USER/g
    s/VAR_DIR/${STAGING_DIR//\//\\/}/g
    " $SCRIPT_PATH/includes/templates/local/dep/deploy.php > local/dep/deploy-staging.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer preproduction$(tput setaf 7)"
    sed "
    s/VAR_FILE/preproduction/g
    s/VAR_SSH_IP/$PREPRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PREPRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PREPRODUCTION_SSH_USER/g
    s/VAR_DIR/${PREPRODUCTION_DIR//\//\\/}/g
    " $SCRIPT_PATH/includes/templates/local/dep/deploy.php > local/dep/deploy-preproduction.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer production$(tput setaf 7)"
    sed "
    s/VAR_FILE/production/g
    s/VAR_SSH_IP/$PRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PRODUCTION_SSH_USER/g
    s/VAR_DIR/${PRODUCTION_DIR//\//\\/}/g
    " $SCRIPT_PATH/includes/templates/local/dep/deploy.php > local/dep/deploy-production.php

}

#deployer sync
function sensiopal_create_step__deployer_sync()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync staging to local$(tput setaf 7)"
    sed "
    s/VAR_FILE/staging/g
    s/VAR_SSH_IP/$STAGING_SSH_IP/g
    s/VAR_SSH_PORT/$STAGING_SSH_PORT/g
    s/VAR_SSH_USER/$STAGING_SSH_USER/g
    s/VAR_DIR/${STAGING_DIR//\//\\/}/g
    s/VAR_DB_NAME/$STAGING_DB_NAME/g
    s/VAR_DB_USER/$STAGING_DB_USER/g
    s/VAR_DB_PASS/$STAGING_DB_PASS/g
    s/VAR_DB_HOST/$STAGING_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-from.php > local/dep/sync-from-staging.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync preproduction to local$(tput setaf 7)"
    sed "
    s/VAR_FILE/preproduction/g
    s/VAR_SSH_IP/$PREPRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PREPRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PREPRODUCTION_SSH_USER/g
    s/VAR_DIR/${PREPRODUCTION_DIR//\//\\/}/g
    s/VAR_DB_NAME/$PREPRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PREPRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PREPRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PREPRODUCTION_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-from.php > local/dep/sync-from-preproduction.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync production to local$(tput setaf 7)"
    sed "
    s/VAR_FILE/production/g
    s/VAR_SSH_IP/$PRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PRODUCTION_SSH_USER/g
    s/VAR_DIR/${PRODUCTION_DIR//\//\\/}/g
    s/VAR_DB_NAME/$PRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PRODUCTION_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-from.php > local/dep/sync-from-production.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync local to staging$(tput setaf 7)"
    sed "
    s/VAR_FILE/staging/g
    s/VAR_SSH_IP/$STAGING_SSH_IP/g
    s/VAR_SSH_PORT/$STAGING_SSH_PORT/g
    s/VAR_SSH_USER/$STAGING_SSH_USER/g
    s/VAR_DIR/${STAGING_DIR//\//\\/}/g
    s/VAR_DB_NAME/$STAGING_DB_NAME/g
    s/VAR_DB_USER/$STAGING_DB_USER/g
    s/VAR_DB_PASS/$STAGING_DB_PASS/g
    s/VAR_DB_HOST/$STAGING_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-to.php > local/dep/sync-to-staging.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync local to preproduction$(tput setaf 7)"
    sed "
    s/VAR_FILE/preproduction/g
    s/VAR_SSH_IP/$PREPRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PREPRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PREPRODUCTION_SSH_USER/g
    s/VAR_DIR/${PREPRODUCTION_DIR//\//\\/}/g
    s/VAR_DB_NAME/$PREPRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PREPRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PREPRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PREPRODUCTION_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-to.php > local/dep/sync-to-preproduction.php

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create deployer sync local to production$(tput setaf 7)"
    sed "
    s/VAR_FILE/production/g
    s/VAR_SSH_IP/$PRODUCTION_SSH_IP/g
    s/VAR_SSH_PORT/$PRODUCTION_SSH_PORT/g
    s/VAR_SSH_USER/$PRODUCTION_SSH_USER/g
    s/VAR_DIR/${PRODUCTION_DIR//\//\\/}/g
    s/VAR_DB_NAME/$PRODUCTION_DB_NAME/g
    s/VAR_DB_USER/$PRODUCTION_DB_USER/g
    s/VAR_DB_PASS/$PRODUCTION_DB_PASS/g
    s/VAR_DB_HOST/$PRODUCTION_DB_HOST/g
    " $SCRIPT_PATH/includes/templates/local/dep/sync-to.php > local/dep/sync-to-production.php

}

#new docker-compose
function sensiopal_create_step__docker_compose()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create docker-compose$(tput setaf 7)"
    sed "
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    s/VAR_LOCAL_DP_USER/$LOCAL_DP_USER/g
    s/VAR_LOCAL_DP_PASS/$LOCAL_DP_PASS/g
    " $SCRIPT_PATH/includes/templates/local/config.yml > local/config.yml

}

#new Dockerfile webserver
function sensiopal_create_step__dockerfile_webserver()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create Dockerfile Webserver$(tput setaf 7)"
    sed "
    s/VAR_FILE/dockerfile/g
    " $SCRIPT_PATH/includes/templates/local/bin/webserver/Dockerfile > local/bin/webserver/Dockerfile

}

#new Dockerfile webserver
function sensiopal_create_step__dockerfile_mysql()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create Dockerfile Mysql$(tput setaf 7)"
    sed "
    s/VAR_FILE/dockerfile/g
    " $SCRIPT_PATH/includes/templates/local/bin/mysql/Dockerfile > local/bin/mysql/Dockerfile
    
}

#new php ini
function sensiopal_create_step__php_ini()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create php ini$(tput setaf 7)"
    sed "
    s/VAR_FILE/php.ini/g
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    " $SCRIPT_PATH/includes/templates/local/php/app.ini > local/php/app.ini
    
}

#new virtual hosts
function sensiopal_create_step__vhost()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create virtual hosts$(tput setaf 7)"
    sed "
    s/VAR_LOCAL_DOMAIN/$LOCAL_DOMAIN/g
    " $SCRIPT_PATH/includes/templates/local/conf/app.conf > local/conf/app.conf

}

#new npm gulpfile
function sensiopal_create_step__npm_package()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create php ini$(tput setaf 7)"
    sed "
    s/VAR_FILE/package/g
    " $SCRIPT_PATH/includes/templates/local/npm/package.json > local/npm/package.json

}

#new npm gulpfile
function sensiopal_create_step__npm_gulpfile()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create php ini$(tput setaf 7)"
    sed "
    s/VAR_FILE/gulpfile/g
    " $SCRIPT_PATH/includes/templates/local/npm/gulpfile.js > local/npm/gulpfile.js

}

#new docs
function sensiopal_create_step__docs()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create documentation 1/4$(tput setaf 7)"
    sed "
    s/VAR_FILE/specifications/g
    s/VAR_LINK_REDMINE/${LINK_REDMINE//\//\\/}/g
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    " $SCRIPT_PATH/includes/templates/doc/specifications.md > doc/specifications.md

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create documentation 2/4$(tput setaf 7)"
    sed "
    s/VAR_FILE/specifications/g
    s/VAR_LINK_REDMINE/${LINK_REDMINE//\//\\/}/g
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    s/VAR_STAGING_DOMAIN/$STAGING_DOMAIN/g
    s/VAR_STAGING_DIR/${STAGING_DIR//\//\\/}/g
    s/VAR_STAGING_SSH_USER/$STAGING_SSH_USER/g
    s/VAR_STAGING_SSH_IP/$STAGING_SSH_IP/g
    s/VAR_STAGING_SSH_PORT/$STAGING_SSH_PORT/g
    s/VAR_STAGING_DB_NAME/$STAGING_DB_NAME/g
    s/VAR_STAGING_DB_PREFIX/$STAGING_DB_PREFIX/g
    s/VAR_STAGING_DB_USER/$STAGING_DB_USER/g
    s/VAR_STAGING_DB_PASS/$STAGING_DB_PASS/g
    s/VAR_STAGING_DB_HOST/$STAGING_DB_HOST/g
    s/VAR_STAGING_DP_USER/$STAGING_DP_USER/g
    s/VAR_STAGING_DP_PASS/$STAGING_DP_PASS/g
    s/VAR_STAGING_BRANCH/${STAGING_BRANCH//\//\\/}/g
    s/VAR_PREPRODUCTION_DOMAIN/$PREPRODUCTION_DOMAIN/g
    s/VAR_PREPRODUCTION_DIR/${PREPRODUCTION_DIR//\//\\/}/g
    s/VAR_PREPRODUCTION_SSH_USER/$PREPRODUCTION_SSH_USER/g
    s/VAR_PREPRODUCTION_SSH_IP/$PREPRODUCTION_SSH_IP/g
    s/VAR_PREPRODUCTION_SSH_PORT/$PREPRODUCTION_SSH_PORT/g
    s/VAR_PREPRODUCTION_DB_NAME/$PREPRODUCTION_DB_NAME/g
    s/VAR_PREPRODUCTION_DB_PREFIX/$PREPRODUCTION_DB_PREFIX/g
    s/VAR_PREPRODUCTION_DB_USER/$PREPRODUCTION_DB_USER/g
    s/VAR_PREPRODUCTION_DB_PASS/$PREPRODUCTION_DB_PASS/g
    s/VAR_PREPRODUCTION_DB_HOST/$PREPRODUCTION_DB_HOST/g
    s/VAR_PREPRODUCTION_DP_USER/$PREPRODUCTION_DP_USER/g
    s/VAR_PREPRODUCTION_DP_PASS/$PREPRODUCTION_DP_PASS/g
    s/VAR_PREPRODUCTION_BRANCH/${PREPRODUCTION_BRANCH//\//\\/}/g
    s/VAR_PRODUCTION_DOMAIN/$PRODUCTION_DOMAIN/g
    s/VAR_PRODUCTION_DIR/${PRODUCTION_DIR//\//\\/}/g
    s/VAR_PRODUCTION_SSH_USER/$PRODUCTION_SSH_USER/g
    s/VAR_PRODUCTION_SSH_IP/$PRODUCTION_SSH_IP/g
    s/VAR_PRODUCTION_SSH_PORT/$PRODUCTION_SSH_PORT/g
    s/VAR_PRODUCTION_DB_NAME/$PRODUCTION_DB_NAME/g
    s/VAR_PRODUCTION_DB_PREFIX/$PRODUCTION_DB_PREFIX/g
    s/VAR_PRODUCTION_DB_USER/$PRODUCTION_DB_USER/g
    s/VAR_PRODUCTION_DB_PASS/$PRODUCTION_DB_PASS/g
    s/VAR_PRODUCTION_DB_HOST/$PRODUCTION_DB_HOST/g
    s/VAR_PRODUCTION_DP_USER/$PRODUCTION_DP_USER/g
    s/VAR_PRODUCTION_DP_PASS/$PRODUCTION_DP_PASS/g
    s/VAR_PRODUCTION_BRANCH/${PRODUCTION_BRANCH//\//\\/}/g
    " $SCRIPT_PATH/includes/templates/doc/environnements.md > doc/environnements.md

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create documentation 3/4$(tput setaf 7)"
    sed "
    s/VAR_FILE/services/g
    s/VAR_LINK_REDMINE/${LINK_REDMINE//\//\\/}/g
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    " $SCRIPT_PATH/includes/templates/doc/services.md > doc/services.md

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create documentation 4/4$(tput setaf 7)"
    sed "
    s/VAR_FILE/documentation/g
    s/VAR_LINK_REDMINE/${LINK_REDMINE//\//\\/}/g
    s/VAR_PROJECT_ID/$PROJECT_ID/g
    " $SCRIPT_PATH/includes/templates/doc/documentation.md > doc/documentation.md

}

#new certificates
function sensiopal_create_step__cert()
{

    rm -rf local/ssl/*
    
    if [ ! -e ~/SENSIOPAL/$PROJECT_ID/local/ssl/req.cnf ];
        then

            echo "$(tput setaf 6)SENSIOPAL::INIT - Create certificates$(tput setaf 7)"
            
            openssl genrsa -des3 -out local/ssl/$PROJECT_ID.key -passout pass:sensiopal 2048
            openssl req -x509 -new -nodes -key local/ssl/$PROJECT_ID.key -passin pass:sensiopal -sha256 -days 1024 -out local/ssl/$PROJECT_ID.pem -subj "/C=FR/ST=Paris/L=Paris/O=$PROJECT_ID/OU=$PROJECT_ID/CN=$LOCAL_DOMAIN"
            echo $PASS | sudo -S security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain local/ssl/$PROJECT_ID.pem
            openssl req -new -sha256 -nodes -out local/ssl/cert.csr -newkey rsa:2048 -keyout local/ssl/cert.key -config <( printf "[req]\ndefault_bits = 2048\nprompt = no\ndefault_md = sha256\ndistinguished_name = dn\n[dn]\nC=US\nST=RandomState\nL=RandomCity\nO=RandomOrganization\nOU=RandomOrganizationUnit\nemailAddress=hello@$LOCAL_DOMAIN\nCN = $LOCAL_DOMAIN" )
            openssl x509 -req -in local/ssl/cert.csr -CA local/ssl/$PROJECT_ID.pem -CAkey local/ssl/$PROJECT_ID.key -CAcreateserial -out local/ssl/cert.crt -days 365 -sha256 -passin pass:sensiopal -extfile <( printf "authorityKeyIdentifier=keyid,issuer\nbasicConstraints=CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = @alt_names\n\n[alt_names]\nDNS.1 = $LOCAL_DOMAIN" )
            openssl x509 -req -in local/ssl/cert.csr -CA local/ssl/$PROJECT_ID.pem -CAkey local/ssl/$PROJECT_ID.key -CAcreateserial -out local/ssl/cert.en.crt -days 365 -sha256 -passin pass:sensiopal -extfile <( printf "authorityKeyIdentifier=keyid,issuer\nbasicConstraints=CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = @alt_names\n\n[alt_names]\nDNS.1 = en.$LOCAL_DOMAIN" )

    fi
    
}

#validate certificates
function sensiopal_validate_cert()
{

    if [ ! -e ~/SENSIOPAL/$PROJECT_ID/local/ssl/req.cnf ];
        then

            echo "$(tput setaf 6)SENSIOPAL::CERT - Add $PROJECT_ID certificat$(tput setaf 7)"

            echo $PASS | sudo -S security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain local/ssl/$PROJECT_ID.pem
            
    fi
    
}

#new ssh key
function sensiopal_create_step__ssh()
{

    echo "$(tput setaf 6)SENSIOPAL::INIT - Create ssh key$(tput setaf 7)"

    if [ ! -e ~/SENSIOPAL/$PROJECT_ID/local/ssh/id_rsa ];
        then
            ssh-keygen -t rsa -b 4096 -C "$DEV_EMAIL" -f local/ssh/id_rsa -q -N ""
    fi
    
}