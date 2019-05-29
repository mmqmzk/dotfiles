#!/usr/bin/env zsh
fpath=("${DOT:=$HOME/.dotfiles}/zfuncs" $fpath)
autoload -Uz _sshrc
_sshrc "$@"
