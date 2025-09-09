if [ -n "${SHOW_TMUX_WARNING+x}" ]; then
    echo "Warning: This instance is not running in a tmux instance!"
    echo "If you wish to do so, run tmux."
fi

# TMux shortcut scripts
alias m="~/scripts/common/tmuxer.sh"
alias j="~/scripts/common/untmux.sh"

# Add search additions

alias s="~/scripts/common/search.sh"
alias si="~/scripts/common/searchi.sh"

# Eternal Terminal connection
alias etc="~/scripts/common/et-connect.sh"

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", at:e0165eaa730dd0fa32, defer:2
zplug "zsh-users/zsh-autosuggestions", at:c3d4e576c9c86eac62884

if ! zplug check; then
    zplug install
fi

zplug load

bindkey -e
bindkey '^S' autosuggest-accept

if [[ "$(uname)" == "Darwin" ]]; then
    export CLICOLOR=1
fi

eval "$(~/.starship/starship init zsh)"

# History settings

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
