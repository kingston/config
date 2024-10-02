#!/bin/bash

# This script searches for a query string case insensitive within the current directory, excluding the .git folder.
# Usage: ./script_name.sh {query string}

EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {query string}"
  exit $E_BADARGS
fi

grep -r --exclude-dir=.git --color=auto -i "$*" .

