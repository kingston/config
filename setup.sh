#!/bin/bash
# NAME: Setup Environment
# DESCRIPTION: Sets up the home environment to be nice and homely :)
# NOTE: This script should be able to run repeatedly without overwriting any settings 

# Set up environmnet

ABS_PATH=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname "$ABS_PATH"`

echo $SCRIPT_DIR

echo "Linking .vimrc..."

if [ -L ~/.vimrc ]; then
    echo "Existing .vimrc link detected pointing to:"
    echo "`readlink -f ~/.vimrc`"
    echo "Removing link..."
    rm -f ~/.vimrc
    echo "Link removed!"
fi

if [ -e ~/.vimrc ]; then
    echo ".vimrc already exists - renaming to .vimrc.bak"
    mv ~/.vimrc ~/.vimrc.bak
fi

ln -s $SCRIPT_DIR/.vimrc ~/.vimrc

echo "Successfully linked .vimrc!"
echo ""

echo "Installing Vundle"

if [ -d ~/.vim/bundle/vundle ]; then
    echo "Vundle already is installed.  Skipping installation."
else
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

echo "Vundle installed!"
echo ""

echo "Installing Vundle plugins..."

vim -e -c ":BundleInstall" -c ":quit"

echo "Vundle plugins successfully installed!"

echo "Setting up scripts directory"

if [ ! -d ~/scripts ]; then
    mkdir ~/scripts
fi

if [ -L ~/scripts/common ]; then
    echo "Existing scripts link detected.  Removing now..."
    rm -f ~/scripts/common
fi

if [ -d ~/scripts/common ]; then
    echo "Existing scripts common folder detected.  Stopping now."
    exit 1
fi

ln -s $SCRIPT_DIR/scripts ~/scripts/common

echo "Scripts directory successfully set up!"
echo ""

echo "Setting up .bashrc..."

# Check if the .bashrc file already contains the source line
BASHRCLINE=`grep "Scripts configuration" ~/.bashrc`

if [ "$BASHRCLINE" != "" ]; then
    echo "Skipping .bashrc setup - configuration already detected"
else
    # NOTE: If you want to modify this, you might have a funner time.
    # Some awk fun? 
    echo -e "\n#Scripts configuration\nsource $SCRIPT_DIR/.bashrcadditions\n" >> ~/.bashrc
fi

echo ".bashrc successfully set up!"
echo ""

SETUP_CFG=`dirname $0`/setup.cfg
if [ -f $SETUP_CFG ]; then
    source $SETUP_CFG
    echo "Setting up Git..."
    `dirname $0`/setupGit.sh "$GIT_NAME" "$GIT_EMAIL"
    echo "Git setup!"
else
    echo "No configuration file (setup.cfg) found.  Please set up Git manually."
fi

echo ""

echo "Done setting up!"
echo ""
echo "You may also need to clean up any unused vim bundles by :BundleClean"
echo "You may also need to compile the ruby extension in command-t"
echo "See http://kresimirbojcic.com/2011/05/14/installing-command-t-ubunutu-11.04-ruby-1.9.2.html for more info"
echo "Be sure to enable xterm-256color in terminal settings if you are ssh'ing in"
echo "And also, install dircolors for solarized, e.g. seebi/dircolors-solarized"
echo "Also, symlink .tmux.conf to home if you want tmux settings"
echo "And finally be sure to restart the session to load latest bashrc settings or run source ~/.bashrc"
