#!/usr/bin/env bash

set -e

sudo apt update && sudo apt upgrade -y

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
lib="$HOME/.local/lib"
scripts="$lib/scripts"
if [[ -e "$scripts" ]]; then
  pushd "$scripts" && git pull
  : "$linux/bin" && [[ -d "$_" ]] && rsync -a --delete -C "$scripts/" "$_"
  popd
fi
wsl_scripts="$lib/wsl-scripts"
if [[ -e "$wsl_scripts" ]]; then
  pushd "$wsl_scripts" && git pull
  : "$linux/wsl" && [[ -d "$_" ]] && rsync -a --delete -C "$wsl_scripts/" "$_"
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
