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

# Reassign checkout
git config --global alias.co checkout

git config --global core.editor "vim"

echo "Successfully updated Git settings"
