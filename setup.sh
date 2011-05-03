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

echo "Installing NERDTree to vim directory"
echo "(It might be a good idea to check whether you are downloading the latest version - currently at 4.1.0)"

wget http://www.vim.org/scripts/download_script.php?src_id=11834 -O nerdtree.zip
unzip nerdtree.zip -d ~/.vim
rm -f nerdtree.zip

echo "NERDTree sucessfully installed!"
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
