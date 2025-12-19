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

${PM} install git zsh curl zip unzip \
  rustc cargo golang python3-venv python3-pynvim -y

check_bin

PY_ENV="${LIB:-"$HOME/.local/lib"}/python3"
if [[ ! -d "${PY_ENV}" ]]; then
  python3 -m venv "${PY_ENV}"
fi

PIP="$PY_ENV/bin/pip"
if [[ -x "${PIP}" ]]; then
  echo "Installing pips."
  ${PIP} install pip -U
  ${PIP} install -U ansi2html gita httpie jc mdv \
    mycli neovim pip Pygments pynvim PySocks ranger-fm tabulate \
    visidata xlsx2csv xq youtube-dl yq
fi
# has python || (: "$(wh python3)" && [[ -x "$_" ]] && sudo ln -sfn "$_" "${_%3}")
ln -s "${PY_ENV}/bin/*" "$BIN" || true

if ! has ag; then
  echo "Installing ag."
  if is_debian; then
    : "silversearcher-ag"
  else
    : "the_silver_searcher"
  fi
  ${PM} install "$_" -y
fi

if ! has lua5.4 lua; then
  if is_debian; then
    ${PM} install lua5.4
    ${PM} install lua-filesystem
  else
    ${PM} install lua
  fi
fi

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

mkdir -p ~/.cargo
cat - >~/.cargo/config <<EOF
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
EOF

${PM} install bat eza fd-find hexyl rclone ripgrep -y

sudo ln -sfn /usr/bin/batcat /usr/local/bin/bat || true
sudo ln -sfn /usr/bin/fdfind /usr/local/bin/fd || true

# install_baidu
# install_bat
install_cht
# install_exa
# install_fd
# install_fx
install_fzf
# install_glow
# install_hexyl
install_jq
install_lsd
# install_rclone
# install_ripgrep
# install_v2sub
# install_xsv

install_node "--lts"

install_vim

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.cache"

popd
