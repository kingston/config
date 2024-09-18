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
# 'ap' allows you to stage changes interactively by choosing specific chunks to add.

git config --global alias.co "checkout"
# 'co' is a shortcut for 'git checkout', used to switch branches or restore files.

git config --global alias.cob "checkout -b"
# 'cob' creates a new branch and immediately switches to it.

git config --global alias.dc "diff --cached"
# 'dc' shows the changes that are staged for commit (in the index).

git config --global alias.fe "fetch -p"
# 'fe' fetches from all remotes and prunes branches that no longer exist on the remote.

git config --global alias.ci "commit"
# 'ci' is a shortcut for committing staged changes.

git config --global alias.st "status -sb"
# 'st' shows the status in a short format, displaying branch info and file changes concisely.

git config --global alias.br "branch"
# 'br' lists all branches.

git config --global alias.bd "branch -d"
# 'bd' deletes a local branch (only if it's fully merged).

git config --global alias.bdm "!git branch --merged | egrep -v '^\*|main|prod' | xargs -n 1 git branch -d"
# 'bdm' deletes all merged branches except for 'main' and 'prod'.

git config --global alias.bds "!git checkout -q main && git for-each-ref refs/heads/ \"--format=%(refname:short)\" | while read branch; do mergeBase=\$(git merge-base main \$branch) && [[ \$(git cherry main \$(git commit-tree \$(git rev-parse \$branch\\^{tree}) -p \$mergeBase -m _)) == \"-\"* ]] && git branch -D \$branch; done"
# 'bds' force-deletes all branches that have been fully merged into 'main'.

git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
# 'hist' shows a compact graphical log with the commit hash, date, message, and author.

git config --global alias.uc "reset --soft HEAD~1"
# 'uc' undoes the last commit but keeps the changes in the working directory.

git config --global alias.type "cat-file -t"
# 'type' displays the type of an object in Git (e.g., blob, tree, or commit).

git config --global alias.dump "cat-file -p"
# 'dump' shows the content of an object, such as a file's contents at a specific commit.

git config --global alias.pr "push --set-upstream origin HEAD"
# 'pr' pushes the current branch and sets the upstream tracking branch.

git config --global alias.gm '!git fetch origin main:main && git checkout main'
# 'gm' fetches the latest 'main' branch from the remote and checks it out.

git config --global core.editor "vim"

git config --global core.excludesfile ~/.global_ignore

# Prevent less from showing if content is less than one screen
git config --global --replace-all core.pager "less -F -X"

git config --global init.templatedir "$SCRIPT_DIR/git-templates"

if [ -L ~/.global_ignore ]; then
    rm -f ~/.global_ignore
fi
ln -s $SCRIPT_DIR/.global_ignore ~/.global_ignore

echo "Successfully updated Git settings!"
