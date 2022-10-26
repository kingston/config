if [ -n "${SHOW_TMUX_WARNING+x}" ]; then
    echo "Warning: This instance is not running in a tmux instance!"
    echo "If you wish to do so, run tmux."
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# TMux shortcut scripts
alias m="~/scripts/common/tmuxer.sh"
alias j="~/scripts/common/untmux.sh"

# Add search additions

alias s="~/scripts/common/search.sh"
alias si="~/scripts/common/searchi.sh"


# Antidote

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
