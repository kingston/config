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


# Zplug

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

zplug "robbyrussell/oh-my-zsh", as:plugin, use:"lib/*.zsh", defer:2
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/history-substring-search", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

zplug romkatv/powerlevel10k, as:theme, depth:1

if ! zplug check; then
    zplug install
fi

zplug load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
