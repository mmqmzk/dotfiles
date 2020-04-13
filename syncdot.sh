#!/usr/bin/env bash

pushd "${DOT:-"$HOME/.dotfiles"}"
git pull && git submodule update --init
bash update.bash "$@"
popd
linux="$GOOGLE_DRIVE/Config/Linux"
cfg="${XDG_CONFIG_HOME:-"$HOME/.config"}"
ranger="$cfg/ranger"
if [[ -e "$ranger" ]]; then
  pushd "$ranger" && git pull
  : "$linux" && [[ -d "$_" ]] && rsync -a --delete -C "$ranger" "$_"
  popd
fi
aria2="$cfg/aria2"
if [[ -e "$aria2" ]]; then
  pushd "$aria2" && git pull
  : "$linux" && [[ -d "$_" ]] && rsync -a --delete -C "$aria2" "$_"
  popd
fi
copyq="$cfg/copyq"
if [[ -e "$copyq" && -d "$linux" ]]; then
  rsync -a --delete -C "$copyq" "$linux"
fi
gist="$HOME/.local/lib/gist"
if [[ -d "$gist" ]]; then
  pushd "$gist" && git pull && popd
fi
