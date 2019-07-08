#!/usr/bin/env bash
cd $(dirname "$0")
if [[ ! -f ./functions.sh ]]; then
  echo "functions.sh not found"
  exit 1
fi
source ./functions.sh

if [[ -z "$PM" ]]; then
  echo "yum and apt not found"
  exit 1
fi

if ! has curl; then
  sudo ${PM} install curl -y
fi

if ! has git; then
  echo "Installing git"
  sudo ${PM} install git -y
fi

PY=$(wh python3 python)
if [[ -n "$PY" ]]; then
  PIP=$(wh pip3 pip) 
  if [[ -z "$PIP" ]]; then
    echo "Installing pip"
    GPY="/tmp/get-pip.py"
    del "$GPY"
    curl -sSfL https://bootstrap.pypa.io/get-pip.py > "$GPY"
    ${PY} ${GPY} --user
    export PATH="$HOME/.local/bin:$PATH"
  fi
  ${PIP} --user install pip -U 
  echo "Installing httpie"
  ${PIP} --user install httpie -U 
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

if ! has zsh; then
  echo "Installing zsh"
  sudo ${PM} install zsh -y
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

install_bat "v0.11.0"

install_fd "v7.3.0"

install_ripgrep "11.0.1"

#install_xsv "0.13.0"

install_lsd "0.15.1"

install_fzf

install_vim

install_cht

install_jq "1.6"

install_q

install_node "10"

#install_exa "0.8.0"