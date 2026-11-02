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

zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*' delay 0.1 # seconds (float)

stty quit undef
stty kill undef
stty start undef
stty stop undef
stty werase undef
stty lnext undef
stty discard undef

source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZDOTDIR/plugins/zsh-autopair/autopair.zsh
autopair-init
source $ZDOTDIR/plugins/fsh/fast-syntax-highlighting.plugin.zsh

# zsh-vi-mode: zvm_config must be defined BEFORE sourcing the plugin
# (the plugin reads it at the bottom of its file). Bindings live in
# .bindkeyrc as zvm_after_init, which the plugin calls at the end of
# zvm_init.
# ZVM_LAZY_KEYBINDINGS is read DURING sourcing (it creates the deferred
# binding list), so it cannot live in zvm_config -- it must be set here.
ZVM_LAZY_KEYBINDINGS=false
function zvm_config() {
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
  ZVM_KEYTIMEOUT=0.3             # plugin key-reader wait: operator chords
                                 # (d/c/y + motion/text object). The
                                 # KEYTIMEOUT=30 it derives during zvm_init
                                 # is overridden by zvm_after_init in
                                 # .bindkeyrc (KEYTIMEOUT=1) on purpose.
  ZVM_VI_ESCAPE_BINDKEY='<ESC>'
  ZVM_SYSTEM_CLIPBOARD_ENABLED=true
  ZVM_CLIPBOARD_USE_OSC52=true   # Y -> system clipboard (nvim "+y)
}
source $ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

source $ZDOTDIR/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZDOTDIR/plugins/tokyonight.zsh-fsh/extras/zsh-autocomplete/tokyonight-night.zsh
source $ZDOTDIR/plugins/tokyonight.zsh-fsh/extras/history-substring-search/tokyonight-night.zsh

source $ZDOTDIR/.aliasrc
source $ZDOTDIR/.bindkeyrc

# Called whenever you change dirs, to give you a chance to write the new dir to file.
# NOTE: If you override the function above, then you are *required* to override this one, too. Can
# be left empty, though.
chpwd_recent_dirs() { }

unset HISTFILE
eval "$(starship init zsh)"

# opencode
export PATH=/home/b1n/.opencode/bin:$PATH
