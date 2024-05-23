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

eval "$(starship init zsh)"
