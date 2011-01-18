#/bin/sh

# Parameter checking

EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]; then
    echo Usage: $0 username email
    exit $E_BADARGS
fi

# Sets up Git
git config --global user.name "$1"
git config --global user.email "$2"

# Create alias shortcuts
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.br branch
git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
git config --global alias.type "cat-file -t"
git config --global alias.dump "cat-file -p"

git config --global core.editor "vim"

echo "Successfully updated Git settings"
