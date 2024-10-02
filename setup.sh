#!/bin/bash
#
# Setup Environment
# =================
# 
# Sets up the home environment by creating symbolic links for configuration files 
# in the user's home directory. The script ensures that it can be rerun safely 
# without overwriting existing settings, renaming old files when necessary.
#
# NOTE: This script should be able to run repeatedly without overwriting any settings.

# Abort on the first error to ensure the script doesn't continue in an inconsistent state
set -e

# Get the absolute path of the current script, which is used to locate config files
ABS_PATH=$(cd "${0%/*}" && echo "$PWD/${0##*/}")
SCRIPT_DIR=$(dirname "$ABS_PATH")

## Helper Functions
## ================

# Function to print bold text
print_bold() {
    echo -e "\033[1m$1\033[0m"
}

# Function to check if a command exists in the system
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create symbolic links in the home directory.
# It ensures that existing links are handled, and backups are made for existing files.
link_to_home() {
    local target=$1

    # Check if the target is already a symbolic link
    if [ -L "~/$target" ]; then
        local current_link
        current_link=$(readlink "~/$target")

        # Check if the current link points to the correct destination
        if [ "$current_link" == "$SCRIPT_DIR/$target" ]; then
            echo "Link for $target is correct. No changes needed."
            return
        else
            echo "Existing link for $target detected, pointing to: $current_link"
            rm -f "~/$target"
            echo "Old link removed!"
        fi
    fi

    # If the target exists as a regular file or directory, rename it with a .bak extension
    if [ -e ~/"$target" ]; then
        echo "$target already exists - renaming to $target.bak"
        mv ~/"$target" ~/"$target".bak
    fi

    # Create a new symbolic link from the script directory to the home directory
    ln -s "$SCRIPT_DIR/$target" ~/"$target"

    echo "Successfully linked $target!"
}

# Function to upsert a line into a config file
upsert_config_init() {
    # Arguments: 1. Config file, 2. Init file path
    local config_file="$1"
    local init_file="$2"
    local comment="# config initialization"

    # Check if the comment line is already in the file
    if grep -q "$comment" "$config_file"; then
        # Comment exists, check if the correct init file is present
        if ! grep -q "source $init_file $comment" "$config_file"; then
            # Correct init file is not present, update the line
            sed -i '' "s|^source .*$comment|source $init_file $comment|" "$config_file"
            echo "Updated the config initialization line for $config_file."
        else
            echo "Correct config initialization already present in $config_file."
        fi
    else
        # Comment and init file not found, append new line
        echo -e "\nsource $init_file $comment" >> "$config_file"
        echo "Appended the config initialization line to $config_file."
    fi
}

echo "Script directory: $SCRIPT_DIR"
echo ""


## Vim Configuration
## =================

print_bold "Setting up Vim configuration..."

link_to_home .vimrc

if [ -e ~/.vim/autoload/plug.vim ]; then
    echo "Plug already is installed.  Skipping installation."
else
    echo "Installing Vim Plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Plug installed!"
fi

echo "Installing Vim Plug plugins..."

vim +PlugClean! +PlugInstall +qall

echo "Vim plug plugins successfully installed!"

## Scripts Directory
## =================

echo ""
print_bold "Setting up scripts directory..."

# Ensure the ~/scripts directory exists
if [ ! -d ~/scripts ]; then
    mkdir ~/scripts
    echo "Created ~/scripts directory."
fi

# Check if ~/scripts/common is already a symlink
if [ -L ~/scripts/common ]; then
    current_link=$(readlink ~/scripts/common)

    # Check if the current link points to the correct destination
    if [ "$current_link" == "$SCRIPT_DIR/scripts" ]; then
        echo "Link for ~/scripts/common is correct. No changes needed."
    else
        echo "Existing link for ~/scripts/common detected, pointing to: $current_link"
        rm -f ~/scripts/common
        echo "Old link removed!"
    fi
fi

# If the target does not exist, create new symbolic link
if [ ! -e ~/scripts/common ]; then
    ln -s "$SCRIPT_DIR/scripts" ~/scripts/common
    echo "Scripts directory successfully set up!"
fi

## ZSH Configuration
## =================

echo ""
print_bold "Setting up ZSH configuration..."

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

touch ~/.zshrc

# Check if the .zshrc file already contains the source line
upsert_config_init ~/.zshrc "$SCRIPT_DIR/init.zsh"

if [ ! -d ~/.zplug ]; then
    echo "Installing ZPlug..."
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

echo "Checking if any zsh plugins needs install..."
zsh -i -c exit

# Install Starship
if [ ! -d ~/.starship ]; then
    echo "Installing Starship prompt..."
    mkdir ~/.starship
    curl -sL --proto-redir -all,https https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.starship
fi

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

link_to_home .config/starship.toml

## Bash Configuration
## ==================

echo ""
print_bold "Setting up Bash configuration..."

upsert_config_init ~/.bashrc "$SCRIPT_DIR/.bashrcadditions"

link_to_home .inputrc

## Git Configuration
## =================

echo ""
print_bold "Setting up Git configuration..."

SETUP_CFG=`dirname $0`/setup.cfg
if [ -f $SETUP_CFG ]; then
    source $SETUP_CFG
    echo "Setting up Git..."
    `dirname $0`/setupGit.sh "$GIT_NAME" "$GIT_EMAIL"
else
    echo "No configuration file (setup.cfg) found.  Please set up Git manually."
fi

## Completion Notes
## ================

echo ""
print_bold "Done setting up!"

echo ""
echo "Be sure to enable xterm-256color in terminal settings if you are ssh'ing in"
echo "And also, install dircolors for solarized, e.g. seebi/dircolors-solarized"
echo "Also, symlink .tmux.conf to home if you want tmux settings"
echo ""
