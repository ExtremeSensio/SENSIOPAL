#!/bin/bash

echo "$(tput setaf 6)"
echo "   _________  ______________  ___  ____ __"
echo "  / __/ __/ |/ / __/  _/ __ \/ _ \/ _  / /"
echo " _\ \/ _//    /\ \_/ // /_/ / ___/ _  / / "
echo "/___/___/_/|_/___/___/\____/_/  /_//_/___/"
echo "------------------------------ CLI INSTALL"
echo "$(tput setaf 7)"

SCRIPT_DIR=~/.SENSIOPAL
GITHUB_TOKEN=$1
SENSIOPAL_SCRIPT_VERSION=0

sensiopal_install()
{

    echo -n "$(tput setaf 6)SENSIOPAL::INSTALL...$(tput setaf 7)"
    
    mkdir -p $SCRIPT_DIR

    echo "$GITHUB_TOKEN" > $SCRIPT_DIR/token

    if [ -e $SCRIPT_DIR/version ] 
        then
            SENSIOPAL_SCRIPT_VERSION=$(cat $SCRIPT_DIR/version)

    fi

    SENSIOPAL_SCRIPT_VERSION_LATEST=$(curl -H "Authorization: token $GITHUB_TOKEN" -L curl --silent "https://api.github.com/repos/ExtremeSensio/SENSIOPAL/releases/latest" | sed -n 's/.*"tag_name": "\(.*\)",/\1/p')

    if [ $SENSIOPAL_SCRIPT_VERSION == $SENSIOPAL_SCRIPT_VERSION_LATEST ]
      then
          echo -n " $(tput setaf 2)OK SENSIOPAL v.$SENSIOPAL_SCRIPT_VERSION already installed and up to date$(tput setaf 7)"
          echo
      else
          echo "$(tput setaf 6)Download v.$SENSIOPAL_SCRIPT_VERSION_LATEST...$(tput setaf 7)"
          mkdir $SCRIPT_DIR/.download
          curl -H "Authorization: token $GITHUB_TOKEN" -L https://api.github.com/repos/ExtremeSensio/SENSIOPAL/tarball -o $SCRIPT_DIR/.download/update.tar.gz
          tar -xvf $SCRIPT_DIR/.download/update.tar.gz -C $SCRIPT_DIR/.download
          rm $SCRIPT_DIR/.download/update.tar.gz
          mv $SCRIPT_DIR/.download/*/sensiopal.sh $SCRIPT_DIR
          mv $SCRIPT_DIR/.download/*/includes $SCRIPT_DIR
          rm -R $SCRIPT_DIR/.download
          echo "$SENSIOPAL_SCRIPT_VERSION_LATEST" > $SCRIPT_DIR/version
          sleep .5
          echo "$(tput setaf 2)SENSIOPAL v.$SENSIOPAL_SCRIPT_VERSION_LATEST installed$(tput setaf 7)"
          sleep .5
          sed -i '' "/source ~\/.SENSIOPAL\/sensiopal.sh/d" ~/.bash_profile
          echo "source $SCRIPT_DIR/sensiopal.sh" >> ~/.bash_profile
          sleep .5
          echo "$(tput setaf 6)Yeah! SENSIOPAL installed. Close this terminal and enjoy the new 'sensiopal' or 'sd' command$(tput setaf 7)"
    
    fi

}

# OS detection
osdetect=$(uname)
if [[ "$osdetect" == 'Darwin' ]]; then

  sensiopal_install
  
fi
