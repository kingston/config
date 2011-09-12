#!/bin/bash

# A helpful script to load all the files from the current status into buffer

$EDITOR `git status -uall --porcelain | sed 's/^ *[^ ]* *//' | sed 's/^[^ ]* -> //'`
