#!/bin/bash

# A helpful script to load all the files from a commit into buffer

$EDITOR `git show --pretty='format:' --name-only $1`
