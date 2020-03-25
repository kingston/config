#!/bin/bash
# NAME: Setup Environment
# DESCRIPTION: Sets up the home environment to be nice and homely :)
# NOTE: This script should be able to run repeatedly without overwriting any settings 

# abort on first failure
set -e

# Set up environmnet

ABS_PATH=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname "$ABS_PATH"`

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

link_to_home() {
    echo "Linking $@..."

    if [ -L ~/$@ ]; then
        echo "Existing $@ link detected pointing to:"
        echo "`readlink ~/$@`"
        echo "Removing link..."
        rm -f ~/$@
        echo "Link removed!"
    fi

    if [ -e ~/$@ ]; then
        echo "$@ already exists - renaming to $@.bak"
        mv ~/$@ ~/$@.bak
    fi

    ln -s $SCRIPT_DIR/$@ ~/$@

    echo "Successfully linked $@!"
    echo ""
}

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

if ! command_exists zsh; then
    echo "Please install zsh first"
    exit 1
fi

if [ "$(basename "$SHELL")" != "zsh" ]; then
    if ! ZSH_SHELL=$(which zsh); then
        echo "Unable to find zsh command"
        exit 1
    fi
    echo "Attempting to change default shell to $ZSH_SHELL"
    if ! chsh -s "$ZSH_SHELL"; then
        echo "Unable to change default shell. Please change it manually."
    else
        export SHELL="$ZSH_SHELL"
        echo "Shell successfully changed!"
    fi
fi

link_to_home .p10k.zsh

if [ ! -d ~/.zplug ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

echo "Setting up .zshrc"

touch ~/.zshrc

# Check if the .bashrc file already contains the source line
ZSHRCLINE=`grep "Scripts configuration" ~/.zshrc || true`

if [ "$ZSHRCLINE" != "" ]; then
    echo "Skipping .zshrc setup - configuration already detected"
else
    echo -e "\n#Scripts configuration\nsource $SCRIPT_DIR/init.zsh\n" >> ~/.zshrc
fi

echo "Checking if any zsh plugins needs install..."
zsh -i -c exit


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

link_to_home .inputrc

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
echo ""
echo "Make sure to run 'p10k configure' if you need to install fonts"
