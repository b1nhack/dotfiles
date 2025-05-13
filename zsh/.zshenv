export ZDOTDIR="$HOME/.config/zsh"
export KEYTIMEOUT=1

export FPATH="/nix/var/nix/profiles/default/share/zsh/site-functions:$FPATH"
export FPATH="$HOME/.config/zsh/plugins/nix-zsh-completions:$FPATH"
export FPATH="$HOME/.nix-profile/share/zsh/site-functions:$FPATH"

# https://en.wikipedia.org/wiki/Freedesktop.org#Base_Directory_Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EZA_CONFIG_DIR="$HOME/.config/eza"

export EDITOR="nvim"
export LESSHISTFILE="-"
export MANPAGER="nvim +Man!"
export VISUAL="nvim"

export FFSEND_HOST="https://send.dogy.cloud"
export FFSEND_EXPIRY_TIME="1d"
export FFSEND_DOWNLOAD_LIMIT="1"
export FFSEND_ARCHIVE="1"
export FFSEND_VERBOSE="1"

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BAT=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=3
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=3
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
