#!/usr/bin/env bash
cd $(dirname "$0")
if [[ ! -f functions.bash ]]; then
  echo "functions.bash not found"
  exit 1
fi
source functions.bash

if [[ -z "$PM" ]]; then
  echo "yum and apt not found"
  exit 1
fi

sudo ${PM} install git zsh curl zip python3-pip -y

PIP=$(wh pip3 pip) 
if [[ -n "$PIP" ]]; then
  ${PIP} install --user pip -U 
  echo "Installing httpie"
  ${PIP} install --user httpie -U 
fi

if ! has ag; then
  echo "Installing ag"
  if is_debian; then
    AG="silversearcher-ag"
  else
    AG="the_silver_searcher"
  fi
  sudo ${PM} install ${AG} -y
fi

if ! has lua5.3 lua; then
  if is_debian; then 
    sudo $PM install lua5.3
  else
    sudo $PM install lua
  fi
fi

check_bin
install_dot

OMZ="$DOT/oh-my-zsh"
ZRC="$HOME/.zshrc"
del "$ZRC"
echo "Installing oh my zsh"
ln -sf "$DOT/zshrc" "$ZRC"

if ! has tmux; then
  echo "Installing tmux"
  sudo ${PM} install tmux -y
fi
TC=~/.tmux.conf
del "$TC"
ln -sf "$DOT/tmux.conf" "$TC"


echo "Installing git config"
GC=~/.gitconfig
del "$GC"
ln -sf "$DOT/gitconfig" "$GC"

install_bat "v0.12.1"

install_fd "v7.4.0"

install_ripgrep "11.0.2"

install_xsv "0.13.0"

install_lsd "0.16.0"

install_fzf

install_vim

install_cht

install_jq "1.6"

install_q

install_node "10"

install_exa "0.9.0"
