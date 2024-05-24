setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
setopt NO_BG_NICE
setopt NO_NOTIFY
setopt PROMPT_SUBST
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
setopt NO_HIST_BEEP
setopt NO_BEEP
setopt NO_AUTO_REMOVE_SLASH

if [[ -r $ZDOTDIR/.aliasrc ]]; then
	. $ZDOTDIR/.aliasrc
fi

source $ZDOTDIR/plugins/fsh/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
bindkey -M menuselect '^[[C' .forward-char '^[OC' .forward-char

zstyle ':autocomplete:*' min-input 3
zstyle ':autocomplete:*' delay 0.1 # seconds (float)

eval "$(starship init zsh)"
