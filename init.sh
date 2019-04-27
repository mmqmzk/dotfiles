#!/usr/bin/env bash
export PROXY=$@
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

if !has curl; then
    sudo ${PM} install curl -y
fi

if ! has git; then
  echo "Installing git"
  sudo ${PM} install git -y
fi

PY=$(wh python3 python)
if [[ -n "$PY" ]]
then
  PIP=$(wh pip3 pip) 
  if [[ -z "$PIP" ]]; then
    echo "Installing pip"
    GPY="/tmp/get-pip.py"
    del "$GPY"
    curl ${PROXY} -sSfL https://bootstrap.pypa.io/get-pip.py > "$GPY"
    sudo ${PY} ${GPY}
  else
    sudo ${PIP} install pip -U 
  fi
  echo "Installing httpie"
  sudo ${PIP} install httpie -U 
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

check_bin
install_dot

OMZ="$DOT/oh-my-zsh"
ZRC="$HOME/.zshrc"
del "$ZRC"
echo "Installing oh my zsh"
ln -s -f "$DOT/zshrc" "$ZRC"

if ! has tmux; then
    echo "Installing tmux"
    sudo ${PM} install tmux -y
fi
TC=~/.tmux.conf
del "$TC"
ln -s -f "$DOT/tmux.conf" "$TC"


echo "Installing git config"
GC=~/.gitconfig
del "$GC"
ln -s -f "$DOT/gitconfig"  "$GC"

install_bat "v0.10.0"

install_fd "v7.3.0"

install_ripgrep "11.0.1"

install_fzf

install_vim

install_cht

install_jq "1.6"

install_rg

install_q

install_node "11"
