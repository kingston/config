#!/bin/bash

# Run with loadbash to fall back to bash if first session not available
# Otherwise, it will try sessions 0, 1, 2, and 3 to see if they are attachable

# 2 - attached, 1 - detached, 0 - doesn't exist
function getStatus {
    local ATTACH_TEST=`tmux list-sessions 2>&1 | grep ^$1:`
    if [ "$ATTACH_TEST" = "" ]; then
        return 0
    else
        local ATTACH_TEST=`echo $ATTACH_TEST | grep \(attached\)$`
        if [ "$ATTACH_TEST" = "" ]; then
            return 1
        else
            return 2
        fi
    fi
}

function runTmux {
    if [ "$1" -eq "0" ]; then
        env --unset=SHOW_TMUX_WARNING tmux
    else
        env --unset=SHOW_TMUX_WARNING tmux attach -t $2
    fi
    exit 0
}

function runIfDetached {
    getStatus $1
    local STATUS=$?
    if [ "$STATUS" -eq "1" ]; then
        runTmux $STATUS $2
    fi
    return 0
}

function runIfDetachedOrNoExist {
    getStatus $1
    local STATUS=$?
    if [ ! "$STATUS" -eq "2" ]; then
        runTmux $STATUS $1
    fi
    return 0
}

if [ "$1" == "loadbash" ]; then
    runIfDetachedOrNoExist 0
    runIfDetached 1
    runIfDetached 2
    runIfDetached 3
    env SHOW_TMUX_WARNING=1 bash
else
    runIfDetachedOrNoExist 0
    runIfDetachedOrNoExist 1
    runIfDetachedOrNoExist 2
    runIfDetachedOrNoExist 3
    echo "First four tmux instances are attached. Stopping now"
fi

