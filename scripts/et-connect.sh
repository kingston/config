#!/bin/bash

# Connect via Eternal Terminal with iTerm2 tmux Control mode integration
# This script runs on your Mac to connect to your NixOS devbox

if [ -z "$1" ]; then
  echo "Usage: et-connect.sh <user@host[:port]>"
  echo "Example: et-connect.sh kingston@nixos-devbox:2022"
  echo "         et-connect.sh kingston@100.64.0.10:2022"
  echo ""
  echo "This will connect via Eternal Terminal and use iTerm2's tmux Control mode"
  echo "for native iTerm2 tabs, panes, and features with tmux session persistence."
  exit 1
fi

# Extract connection details
CONNECTION="$1"
SESSION_NAME="${2:-main}"

echo "Connecting to $CONNECTION via Eternal Terminal with iTerm2 Control mode..."
echo "Session: $SESSION_NAME"

# Connect via ET and start tmux in Control mode (-CC flag)
# This integrates tmux with iTerm2's native interface
exec et "$CONNECTION" -c "tmux -CC new-session -A -s '$SESSION_NAME'"