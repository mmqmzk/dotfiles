#!/usr/bin/env bash

set -e

sudo bash -c "${PM_UPDATE:-"apt update && apt upgrade -y"}"

pushd "${DOT:-"$HOME/.dotfiles"}"
git pull && git submodule update --init
bash update.bash "$@"
popd

linux="$GOOGLE_DRIVE/Config/Linux"
cfg="${XDG_CONFIG_HOME:-"$HOME/.config"}"
ranger="$cfg/ranger"
if [[ -e "$ranger" ]]; then
  pushd "$ranger" && git pull
  : "$linux" && [[ -d "$_" ]] && rsync -aCh --delete --progress \
    -f "-s __pycache__/" "$ranger" "$_"
  popd
fi
aria2="$cfg/aria2"
if [[ -e "$aria2" ]]; then
  pushd "$aria2" && git pull
  : "$linux" && [[ -d "$_" ]] && rsync -aCh --delete --progress "$aria2" "$_"
  popd
fi
lib="$HOME/.local/lib"
scripts="$lib/scripts"
if [[ -e "$scripts" ]]; then
  pushd "$scripts" && git pull
  : "$linux/bin" && [[ -d "$_" ]] && rsync -aCh --delete \
    --progress "$scripts/" "$_"
  popd
fi
wsl_scripts="$lib/wsl-scripts"
if [[ -e "$wsl_scripts" ]]; then
  pushd "$wsl_scripts" && git pull
  : "$linux/wsl" && [[ -d "$_" ]] && rsync -aCh --delete \
    --progress "$wsl_scripts/" "$_"
  popd
fi
copyq="$cfg/copyq"
if [[ -e "$copyq" && -d "$linux" ]]; then
  rsync -aCh --delete --progress "$copyq" "$linux"
fi
gist="$HOME/.local/lib/gist"
if [[ -d "$gist" ]]; then
  pushd "$gist" && git pull && popd
fi
