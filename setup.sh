#!/bin/bash
# NAME: Setup Environment
# DESCRIPTION: Sets up the home environment to be nice and homely :)
# NOTE: This script should be able to run repeatedly without overwriting any settings 

# abort on first failure
set -e

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

echo "Installing Plug"

if [ -e ~/.vim/autoload/plug.vim ]; then
    echo "Plug already is installed.  Skipping installation."
else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "Plug installed!"
echo ""

echo "Installing Plug plugins..."

vim +PlugClean! +PlugInstall +qall

echo "Plug plugins successfully installed!"

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

if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Setting up .zshrc"

touch ~/.zshrc

# Check if the .bashrc file already contains the source line
ZSHRCLINE=`grep "Scripts configuration" ~/.zshrc || true`

if [ "$ZSHRCLINE" != "" ]; then
    echo "Skipping .zshrc setup - configuration already detected"
else
    echo -e "\n#Scripts configuration\nsource $SCRIPT_DIR/.zshrcadditions\n" >> ~/.zshrc
fi


echo "Setting up .bashrc..."

touch ~/.bashrc

# Check if the .bashrc file already contains the source line
BASHRCLINE=`grep "Scripts configuration" ~/.bashrc || true`

if [ "$BASHRCLINE" != "" ]; then
    echo "Skipping .bashrc setup - configuration already detected"
else
    # NOTE: If you want to modify this, you might have a funner time.
    # Some awk fun? 
    echo -e "\n#Scripts configuration\nsource $SCRIPT_DIR/.bashrcadditions\n" >> ~/.bashrc
fi

echo ".bashrc successfully set up!"
echo ""

echo "Linking .inputrc..."

if [ -L ~/.inputrc ]; then
    echo "Existing .inputrc link detected pointing to:"
    echo "`readlink -f ~/.inputrc`"
    echo "Removing link..."
    rm -f ~/.inputrc
    echo "Link removed!"
fi

if [ -e ~/.inputrc ]; then
    echo ".inputrc already exists - renaming to .inputrc.bak"
    mv ~/.inputrc ~/.inputrc.bak
fi

ln -s $SCRIPT_DIR/.inputrc ~/.inputrc

echo "Successfully linked .inputrc!"
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
echo "Be sure to enable xterm-256color in terminal settings if you are ssh'ing in"
echo "And also, install dircolors for solarized, e.g. seebi/dircolors-solarized"
echo "Also, symlink .tmux.conf to home if you want tmux settings"
echo "And finally be sure to restart the session to load latest bashrc settings or run source ~/.bashrc"
