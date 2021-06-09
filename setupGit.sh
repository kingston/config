#!/bin/sh

# Parameter checking

USERNAME_ARGS_NUMBER=2

ABS_PATH=$(cd ${0%/*} && echo $PWD/${0##*/})
SCRIPT_DIR=`dirname "$ABS_PATH"`

if [ $# -ne $USERNAME_ARGS_NUMBER ] && [ $# -ne 0 ]; then
    echo Usage: $0 [username] [email]
    exit $E_BADARGS
fi

# Sets up Git
if [ $# -eq $USERNAME_ARGS_NUMBER ]; then
    git config --global user.name "$1"
    git config --global user.email "$2"
fi

# Create alias shortcuts
git config --global --remove-section alias

git config --global alias.ap "add -p"
git config --global alias.co "checkout"
git config --global alias.cob "checkout -b"
git config --global alias.dc "diff --cached"
git config --global alias.fe "fetch -p"
git config --global alias.ci "commit"
git config --global alias.st "status -sb"
git config --global alias.br "branch"
git config --global alias.bd "branch -d"
git config --global alias.bdm "!git branch --merged | egrep -v '^\*|master|staging|production' | xargs -n 1 git branch -d"
git config --global alias.bds "!git checkout -q master && git for-each-ref refs/heads/ \"--format=%(refname:short)\" | while read branch; do mergeBase=\$(git merge-base master \$branch) && [[ \$(git cherry master \$(git commit-tree \$(git rev-parse \$branch\\^{tree}) -p \$mergeBase -m _)) == \"-\"* ]] && git branch -D \$branch; done"
git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
git config --global alias.uc "reset --soft HEAD~1"
git config --global alias.type "cat-file -t"
git config --global alias.dump "cat-file -p"
git config --global alias.pr "push --set-upstream origin HEAD"

git config --global core.editor "vim"

git config --global core.excludesfile ~/.global_ignore

# Prevent less from showing if content is less than one screen
git config --global --replace-all core.pager "less -F -X"

git config --global init.templatedir "$SCRIPT_DIR/git-templates"

if [ -L ~/.global_ignore ]; then
    rm -f ~/.global_ignore
fi
ln -s $SCRIPT_DIR/.global_ignore ~/.global_ignore

echo "Successfully updated Git settings"
