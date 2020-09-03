#!/usr/bin/env bash

pushd "$(dirname "$0")"

if [[ ! -f functions.bash ]]; then
  echo "Functions.bash not found."
  exit 1
fi

source functions.bash

if [[ -z "$PM" ]]; then
  echo "Yum and apt not found"
  exit 1
fi

sudo "$PM" install git zsh curl zip unzip python3-pip -y

PIP=$(wh pip3 pip)
if [[ -n "$PIP" ]]; then
  ${PIP} install --user pip -U
  echo "Installing httpie."
  ${PIP} install --user httpie -U
fi
has python || (: "$(wh python3)" && [[ -x "$_" ]] && sudo ln -sfn "$_" "${_%3}")

if ! has ag; then
  echo "Installing ag."
  if is_debian; then
    : "silversearcher-ag"
  else
    : "the_silver_searcher"
  fi
  sudo "$PM" install "$_" -y
fi

if ! has lua5.3 lua; then
  if is_debian; then
    sudo "$PM" install lua5.3
  else
    sudo "$PM" install lua
  fi
fi

check_bin
install_dot

echo "Installing oh my zsh."
: "$HOME/.zshrc" && del "$_" && ln -sfn "$DOT/zshrc" "$_"

if ! has tmux; then
  echo "Installing tmux."
  sudo "$PM" install tmux -y
fi

: "$HOME/.tmux.conf" && del "$_" && ln -sfn "$DOT/tmux.conf" "$_"

echo "Installing git config."
: "$HOME/.gitconfig" && del "$_" && ln -sfn "$DOT/gitconfig" "$_"

: "$DOT/syncdot.sh" && [[ -x "$_" ]] && ln -sfn "$_" "$BIN/syncdot"
: "$DOT/sshrc.d/del" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin
: "$DOT/zfuncs/v" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin


install_jq "1.6"

install_bat
install_cht
install_exa
install_fd
install_fzf
install_lsd
install_q
install_ripgrep
install_vim
install_xsv
install_node "--lts"

popd
