#!/usr/bin/env bash

pushd "$(dirname "$0")"

if [[ ! -f functions.bash ]]; then
  echo "Functions.bash not found."
  exit 1
fi

source functions.bash

if [[ -z "${PM}" ]]; then
  echo "Yum and apt not found"
  exit 1
fi

sudo "${PM}" install git zsh curl zip unzip python3-pip -y

PIP=$(wh pip3 pip)
if [[ -n "${PIP}" ]]; then
  echo "Installing pips."
  ${PIP} install --user pip -U
  ${PIP} install --user httpie -U
  ${PIP} install --user mycli -U
  ${PIP} install --user youtube-dl -U
fi
has python || (: "$(wh python3)" && [[ -x "$_" ]] && sudo ln -sfn "$_" "${_%3}")

if ! has ag; then
  echo "Installing ag."
  if is_debian; then
    : "silversearcher-ag"
  else
    : "the_silver_searcher"
  fi
  sudo "${PM}" install "$_" -y
fi

if ! has lua5.3 lua; then
  if is_debian; then
    sudo "${PM}" install lua5.3
  else
    sudo "${PM}" install lua
  fi
fi

check_bin
install_dot

echo "Installing oh my zsh."
: "${HOME}/.zshrc" && del "$_" && ln -sfn "${DOT}/zshrc" "$_"

if ! has tmux; then
  echo "Installing tmux."
  sudo "${PM}" install tmux -y
fi

: "${HOME}/.tmux.conf" && del "$_" && ln -sfn "${DOT}/tmux.conf" "$_"

echo "Installing git config."
: "${HOME}/.gitconfig" && del "$_" && ln -sfn "${DOT}/gitconfig" "$_"

: "${DOT}/syncdot.sh" && [[ -x "$_" ]] && ln -sfn "$_" "${BIN}/syncdot"
: "${DOT}/sshrc.d/del" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin
: "${DOT}/zfuncs/v" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin

install_jq "1.6"

install_bat v0.17.1
install_cht
install_exa v0.9.0
install_fd v8.2.1
install_fzf
install_lsd 0.19.0
install_q v2.0.19
install_ripgrep 12.1.1
install_vim
install_xsv 0.13.0
install_node "--lts"

popd
