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

${PM} install git zsh curl zip unzip python3-pip rustc golang -y

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
  ${PM} install "$_" -y
fi

if ! has lua5.3 lua; then
  if is_debian; then
    ${PM} install lua5.3
    ${PM} install lua-filesystem
  else
    ${PM} install lua
  fi
fi

check_bin
install_dot

echo "Installing oh my zsh."
: "${HOME}/.zshrc" && del "$_" && ln -sfn "${DOT}/zshrc" "$_"

if ! has tmux; then
  echo "Installing tmux."
  ${PM} install tmux -y
fi

: "${HOME}/.tmux.conf" && del "$_" && ln -sfn "${DOT}/tmux.conf" "$_"

echo "Installing git config."
: "${HOME}/.gitconfig" && del "$_" && ln -sfn "${DOT}/gitconfig" "$_"

: "${DOT}/syncdot.sh" && [[ -x "$_" ]] && ln -sfn "$_" "${BIN}/syncdot"
: "${DOT}/sshrc.d/del" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin
: "${DOT}/zfuncs/v" && [[ -x "$_" ]] && sudo ln -sfn "$_" /usr/local/bin

install_jq

install_bat
install_cht
install_exa
install_fd
install_hexyl
install_lsd
install_ripgrep
install_xsv

install_fzf
install_node "--lts"

install_vim

# install_q v2.0.19

install_baidu
install_glow
install_rclone
install_v2sub

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.cache"

popd
