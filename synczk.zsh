#!/usr/bin/env zsh

pushd "${DOT:-"$HOME/.dotfiles"}"
git pull && git submodule update --init
bash update.bash
popd
local linux="$GOOGLE_DRIVE/Config/Linux"
local cfg="${XDG_CONFIG_HOME:-"$HOME/.config"}"
local ranger="$cfg/ranger"
if [[ -e "$ranger" ]]; then
  pushd "$ranger"
  git pull
  : "$linux"
  [[ -d "$_" ]] && rsync -a --delete --progress -C "$ranger" "$_"
  popd
fi
local aria2="$cfg/aria2"
if [[ -e "$aria2" ]]; then
  pushd "$aria2"
  git pull
  : "$linux"
  [[ -d "$_" ]] && rsync -a --delete --progress -C "$aria2" "$_"
  popd
fi
local copyq="$cfg/copyq"
if [[ -e "$copyq" && -d "$linux" ]]; then
  rsync -a --delete --progress -C "$copyq" "$linux"
fi

  

