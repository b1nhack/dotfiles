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

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

autoload -Uz edit-command-line
zle -N edit-command-line

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
FPATH="$ZDOTDIR/completions:${FPATH}"

source $ZDOTDIR/plugins/fsh/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*' delay 0.1 # seconds (float)

if [[ -r $ZDOTDIR/.aliasrc ]]; then
	. $ZDOTDIR/.aliasrc
fi

if [[ -r $ZDOTDIR/.bindkeyrc ]]; then
	. $ZDOTDIR/.bindkeyrc
fi

stty discard undef
stty lnext undef
stty dsusp undef
stty erase undef
stty kill undef
stty quit undef
stty reprint undef
stty start undef
stty status undef
stty stop undef
stty susp undef
stty werase undef

eval "$(starship init zsh)"
