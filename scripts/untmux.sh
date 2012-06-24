#!/bin/bash

# Run when you get disconnected but the previous tmux session is still active.  This script will allow you to disconnect the client and join it again

echo `tmux list-clients`
echo "Which client to detach?"
read CLIENT
tmux detach-client -t /dev/pts/$CLIENT
/home/kingston/scripts/common/tmuxer.sh
