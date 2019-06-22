#!/usr/bin/env zsh
BASE=${BASE:-$HOME}
DOT=${DOT:-$BASE/.dotfiles}
TMP=${TMP:-$DOT/tmp}
LOCAL=${LOCAL:-$BASE/.local}
pushd $DOT/vim
BRANCH=$(git branch | grep "\*" | cut -d ' ' -f 2)
git checkout console
bash install.sh
rsync -a --progress -f "-s .git" -f "-s tmp" -f "-s youcompleteme/" --delete --delete-excluded $DOT $TMP
git checkout $BRANCH
popd
rsync -a --progress --delete $LOCAL $TMP
mkdir -p $TMP
pushd $TMP
rm -f dot.tbz2
find .local/bin -type l -delete
tar -jcf dot.tbz2 .dotfiles .local
popd

