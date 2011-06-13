#!/bin/bash
# Sets up the environment from the provided folder

echo "Copying .vimrc to local copy..."

if [ -e ~/.vimrc ]; then
    echo ".vimrc already exists - renaming to .vimrc.bak"
    mv ~/.vimrc ~/.vimrc.bak
fi

cp ./.vimrc ~/.vimrc

echo "Successfully copied .vimrc to local copy"
echo ""

echo "Installing Vundle"

git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "Vundle installed!"
echo ""

echo "Setting up scripts directory"

if [ ! -d ~/scripts ]; then
    mkdir ~/scripts
fi

cp ./scripts/* ~/scripts

echo "Scripts directory successfully set up!"
echo ""

echo "Setting up .bashrc..."

cat bashrc.txt >> ~/.bashrc
source ~/.bashrc

echo ".bashrc successfully set up!"
echo ""

echo "Done setting up!"
echo "Remember to run setupGit.sh if you want to set up Git as well"
echo "Also remember to run vim, and :BundleInstall to install plugins"
