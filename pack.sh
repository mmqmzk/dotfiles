#!/usr/bin/env bash

set -e 

BASE=${BASE:-$HOME}
DOT=${DOT:-$BASE/.dotfiles}
TMP=${TMP:-$DOT/tmp}
LOCAL=${LOCAL:-$BASE/.local}

pushd "$DOT/vim"
git checkout console
vim +PlugInstall +PlugUpdate +qa
rsync -ahP -f "-s .git/" -f "-s tmp" -f "-s youcompleteme/" \
  -f "-s .cache" --del "$DOT" "$TMP"
popd

pushd "$DOT"
git submodule update --init
rsync -ahP --del "$LOCAL" "$TMP"
popd

mkdir -p "$TMP"
pushd "$TMP"
rm -f dot.tbz2
find .local/bin -type l -delete
tar -jcf dot.tbz2 .dotfiles .local
popd

