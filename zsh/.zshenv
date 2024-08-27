export ZDOTDIR="$HOME/.config/zsh"
export SAVEHIST=99
export HISTSIZE=999
export KEYTIMEOUT=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export VISUAL="nvim"
export EDITOR="nvim"

. "$HOME/.cargo/env"

export LESSHISTFILE=-
export MANPAGER="nvim +Man!"

export FFSEND_HOST="https://send.ephemeral.land"
export FFSEND_EXPIRY_TIME="1d"
export FFSEND_DOWNLOAD_LIMIT="1"
export FFSEND_ARCHIVE="1"
export FFSEND_VERBOSE="1"

export HOMEBREW_BAT=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=3
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=3
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_BUNDLE_FILE="$HOME/.config/Brewfile"
export HOMEBREW_BUNDLE_NO_LOCK=1

export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

export PERL_CPANM_HOME="$HOME/.cpan/.cpanm"
