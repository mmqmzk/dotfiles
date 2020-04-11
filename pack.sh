#!/usr/bin/env bash
BASE=${BASE:-$HOME}
DOT=${DOT:-$BASE/.dotfiles}
TMP=${TMP:-$DOT/tmp}
LOCAL=${LOCAL:-$BASE/.local}
pushd "$DOT"
pushd "$DOT/vim"
git checkout console
bash install.sh
rsync -a --progress -f "-s .git" -f "-s tmp" -f "-s youcompleteme/" \
  -f "-s .cache" --delete --delete-excluded "$DOT" "$TMP"
popd
git submodule update
rsync -a --progress --delete "$LOCAL" "$TMP"
popd
mkdir -p "$TMP"
pushd "$TMP"
rm -f dot.tbz2
find .local/bin -type l -delete
tar -jcf dot.tbz2 .dotfiles .local
popd

