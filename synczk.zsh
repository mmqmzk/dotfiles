#!/usr/bin/env zsh

pushd "${DOT:-"$HOME/.dotfiles"}"
git pull && git submodule update --init
popd
local linux="$GOOGLE_DRIVE/Config/Linux"
local cfg="${XDG_CONFIG_HOME:-"$HOME/.config"}"
local ranger="$cfg/ranger"
if [[ -e "$_" ]]; then
  pushd "$_"
  git pull
  : "$linux"
  [[ -d "$_" ]] && rsync -a --delete --progress -C "$ranger" "$_"
  popd
fi
local aria2="$cfg/aria2"
if [[ -e "$_" ]]; then
  pushd "$_"
  git pull
  : "$linux"
  [[ -d "$_" ]] && rsync -a --delete --progress -C "$aria2" "$_"
  popd
fi
local copyq="$cfg/copyq"
if [[ -e "$_" && -d "$linux" ]]; then
  rsync -a --delete --progress -C "$copyq" "$linux"
fi

  

