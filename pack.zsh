#!/usr/bin/env zsh
DOT=${DOT:-~/.dotfiles}
TMP="$DOT/tmp"
LOCAL=~/.local
mkdir -p "$TMP"
pushd "$DOT/vim"
git checkout console
bash install.sh
rsync -a --progress -f "-s .git" -f "-s tmp" -f "-s youcompleteme/" --delete --delete-excluded "$DOT" "$TMP"
git checkout vim8
popd
rsync -a --progress --delete "$LOCAL" "$TMP"
pushd "$TMP"
rm -f dot.tbz2
find .local/bin -type l -delete
tar -jcf dot.tbz2 .dotfiles .local
popd

