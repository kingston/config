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

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", at:e0165eaa730dd0fa32, defer:2
zplug "zsh-users/zsh-autosuggestions", at:c3d4e576c9c86eac62884

if ! zplug check; then
    zplug install
fi

zplug load

#compdef pnpm
###-begin-pnpm-completion-###
if type compdef &>/dev/null; then
  _pnpm_completion () {
    local reply
    local si=$IFS

    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "${words[@]}"))
    IFS=$si

    if [ "$reply" = "__tabtab_complete_files__" ]; then
      _files
    else
      _describe 'values' reply
    fi
  }
  # When called by the Zsh completion system, this will end with
  # "loadautofunc" when initially autoloaded and "shfunc" later on, otherwise,
  # the script was "eval"-ed so use "compdef" to register it with the
  # completion system
  if [[ $zsh_eval_context == *func ]]; then
    _pnpm_completion "$@"
  else
    compdef _pnpm_completion pnpm
  fi
fi
###-end-pnpm-completion-###

bindkey '^S' autosuggest-accept

if [[ "$(uname)" == "Darwin" ]]; then
    export CLICOLOR=1
fi

eval "$(~/.starship/starship init zsh)"
