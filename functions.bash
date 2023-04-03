#!/data/data/com.termux/files/usr/bin/bash

set -e

DOT="${DOT:-"${HOME}/.dotfiles"}"
BIN="${BIN:-"${HOME}/.local/bin"}"
LIB="${LIB:-"${HOME}/.local/lib"}"

RUST_ARCH="x86_64-unknown-linux-musl"

has() {
  wh "$@" &>/dev/null
}

wh() {
  for name in "$@"; do
    command which "${name}" 2>/dev/null && return
  done
  return 1
}
PM="$(wh yum apt)"
export PM

is_debian() {
  [[ "${PM}" != *yum* ]]
}

del() {
  for file in "$@"; do
    ([[ -e "${file}" || -L "${file}" ]] &&
      mv --backup=t "$1" /tmp &>/dev/null) ||
      rm -rf "${file}" &>/dev/null
  done
}

version_lte() {
  [[ "$1" == "$(printf "%s\n%s" "$1" "$2" | sort -V | head -n 1)" ]]
}

check_bin() {
  [[ -d "${BIN}" ]] || mkdir -p "${BIN}"
  [[ -d "${LIB}" ]] || mkdir -p "${LIB}"
}

install_dot() {
  if [[ ! -d "${DOT}" ]]; then
    git clone git@github.com:mmqmzk/dotfiles.git "${DOT}" ||
      git clone https://github.com/mmqmzk/dotfiles.git "${DOT}"
  fi
  pushd "${DOT}" &>/dev/null
  git pull --no-rebase || true
  git submodule update --init
  check_bin
  ln -sfn "${DOT}/zsh-custom/diff-so-fancy/diff-so-fancy" "${BIN}/diff-so-fancy"
  ln -sfn "${DOT}/zfuncs/sshrc" "${BIN}/sshrc"
  ln -sfn "${DOT}/zfuncs/v" "${BIN}/v"
  [[ -e ~/.sshrc.d ]] || ln -s "${DOT}/sshrc.d" ~/.sshrc.d
  # if [[ "${HOME}" != /root ]]; then
    # mkdir -p /root/.local
    # ln -s "${BIN}" /root/.local/bin || true
  # fi
  popd
}

add_v() {
  : "$1"
  [[ "$2" == v* ]] && [[ "$_" != v* ]] && : "v$_"
  [[ "$2" == V* ]] && [[ "$_" != V* ]] && : "V$_"
  echo "$_"
}

check_current_tag() {
  : "$("$1" --version 2>&1 |
    grep -iv "command not found" |
    grep -v '未找到命令' |
    grep -Eio 'v?[0-9]+[0-9.]*' |
    sed '1q')"
  : "$(add_v "$_" "$2")"
  if [[ -n "$_" ]] && version_lte "$2" "$_"; then
    echo "Tool $1 already up to date, version: $_."
  else
    return 1
  fi
}

get_tag_url() {
  if ! has jq; then
    echo "Tool jq not Installed." && exit 1
  fi
  curl -fsSL "https://api.github.com/repos/$1/releases/${2:-latest}" \
    -H "Authorization: token $GITHUB_TOKEN" |
    jq "{url:.assets[].browser_download_url,tag:.tag_name}\
    |select(.url|contains(\"${3:-"${RUST_ARCH}"}\"))|.url+\" \"+.tag" -r |
    sed '1q'
}

_download() {
  local url="$1"
  local dir="$2"
  local result="$3"
  del "${dir}"
  mkdir -p "${dir}" && pushd "${dir}" &>/dev/null
  curl -fsSL "${url}" -o "${result}"
  case "${result}" in
  *.tar.* | *.tar)
    tar -xf "${result}" && del "${result}"
    ;;
  *.zip)
    unzip -o "${result}" && del "${result}"
    ;;
  esac
  popd &>/dev/null
}

_link() {
  check_bin
  : "$(find "$1" -name "*$2*" -type f -perm -555 | sed '1q')"
  ln -sfn "$_" "${BIN}/$2"
  : "$(ls -l --color=always "$_")"
  echo "Linked $_."
  local -a files
  files=$(find "$1" -name "*.1" -type f)
  if (("${#files}")); then
    cp -f "${files[@]}" /usr/local/share/man/man1
    mandb || true
  fi
}

install_rust() {
  local module="$1"
  # cargo install "${module}"
  # local bin="$2"
  # local repo="$3"
  # local tag="${4:-"latest"}"
  # [[ "${tag}" == "-f" ]] && tag="latest" && local force="YES"
  # local arch="${5:-"${RUST_ARCH}"}"
  # local url
  # local result="${module}-${tag}-${arch}.tar.gz"
  # if [[ "${tag}" == "latest" ]]; then
  # local data
  # data="$(get_tag_url "${repo}" "${tag}" "${arch}")"
  # url="${data%% *}"
  # tag="${data##* }"
  # if [[ -z "${force}" ]] && check_current_tag "${bin}" "${tag}"; then
  # return
  # fi
  # result="${result//latest/${tag}}"
  # else
  # url="https://github.com/${repo}/releases/download/${tag}/${result}"
  # fi
  # echo "Installing ${module} ${tag}."
  # local dir="${LIB}/${module}"
  # _download "${url}" "${dir}" "${result}"
  # _link "${dir}" "${bin}"
  ${PM} install -y "${module}"
}

install_bat() {
  install_rust bat bat "sharkdp/bat" "$1"
}

install_delta() {
  install_rust git-delta delta "dandavison/delta" "$1"
}

install_fd() {
  install_rust fd fd "sharkdp/fd" "$1"
}
install_hexyl() {
  install_rust hexyl hexyl "sharkdp/hexyl" "$1"
}

install_lsd() {
  install_rust lsd lsd "Peltoche/lsd" "$1" "x86_64-unknown-linux-gnu"
}

install_ripgrep() {

  install_rust ripgrep rg "BurntSushi/ripgrep" "$1"
}

install_xsv() {
  install_rust xsv "xsv" "BurntSushi/xsv" "$1"
}

install_fzf() {
  ${PM} install -y fzf
  # if [[ "$1" == "init" ]]; then
    # install_dot
  # fi
  # local fzf_base="${FZF_BASE:-"${DOT}/fzf"}"
  # if [[ -d "${fzf_base}" ]]; then
    # echo "Installing fzf."
    # bash "${fzf_base}/install" --bin
    # ln -sfn "${fzf_base}/bin/fzf" "${BIN}"
  # fi
}

install_jq() {
  ${PM} install -y jq
  # if is_debian; then
    # ${PM} install jq jo -y
  # else
    # local JQ_TAG=$1
    # [[ -z "${JQ_TAG}" ]] && return 1
    # echo "Installing jq ${JQ_TAG}"
    # local result="jq-linux64"
    # local dir="${LIB}/jq"
    # : "https://github.com/stedolan/jq/releases/download/jq-${JQ_TAG}/${result}"
    # _download "$_" "${dir}" "${result}"
    # chmod 755 "${dir}/${result}"
    # _link "${dir}" "jq"
  # fi
}

install_vim() {
  if [[ $1 == "init" ]]; then
    install_dot
  fi
  echo "Installing vim"
  ${PM} install vim -y
  pushd ~ &>/dev/null
  del ~/.vim*
  local VIMDIR="${DOT}/vim"
  ln -sfn "${VIMDIR}" ~/.vim
  bash "${VIMDIR}/install.sh"
  popd &>/dev/null
}

install_cht() {
  echo "Installing cheat.sh"
  check_bin
  # : "/tmp/cht"
  : "cht"
  del "$_"
  curl -sSfL http://cht.sh/:cht.sh -o "$_"
  chmod 755 "$_"
  mv -f "$_" "${BIN}"
}

install_q() {
  local tag=${1:-latest}
  [[ "${tag}" == "-f" ]] && tag="latest" && local force="YES"
  local result="q-x86_64-Linux"
  local url="https://github.com/harelba/q/releases/download/${tag}/${result}"
  if [[ "${tag}" == "latest" ]]; then
    local data
    data="$(get_tag_url "harelba/q" "${tag}" "${result}")"
    url="${data%% *}"
    tag="${data##* }"
    if [[ -z "${force}" ]] && check_current_tag "q" "${tag}"; then
      return
    fi
    result="${result//latest/${tag}}"
  fi
  echo "Installing q ${tag}."
  local dir="${LIB}/q"
  _download "${url}" "${dir}" "${result}"
  chmod 755 "${dir}/${result}"
  _link "${dir}" "q"
}

install_node() {
  ${PM} install -y nodejs
  # : "${NVM_DIR:-"${DOT}/nvm"}/nvm.sh"
  # if [[ -f "$_" ]]; then
    # source "$_"
  # else
    # echo "Tool nvm not installed."
    # return 1
  # fi
  # local NVMRC="${HOME}/.nvmrc"
  # local CURRENT_VERSION
  # CURRENT_VERSION="$(nvm current 2>/dev/null)"
  # local NODE_TAG
  # NODE_TAG="$(nvm ls-remote "$1" 2>/dev/null |
    # grep -Eo 'v[0-9.]+' |
    # sort -V |
    # tail -n 1)"
  # [[ -z "${NODE_TAG}" ]] && echo "Node version $1 not found." && return 1
  # if [[ "${NODE_TAG}" != "${CURRENT_VERSION}" ]]; then
    # if nvm install "${NODE_TAG}"; then
      # echo "${NODE_TAG}" >"${NVMRC}"
      # nvm alias default "${NODE_TAG}"
      # nvm use --delete-prefix default
      # install_npm
    # else
      # echo "Install node version ${NODE_TAG} failed."
      # return 1
    # fi
    # if nvm version "${CURRENT_VERSION}" &>/dev/null; then
      # nvm uninstall "${CURRENT_VERSION}"
    # fi
  # else
    # echo "Node version ${NODE_TAG} alreday installed."
  # fi
}

install_npm() {
  if ! has npm; then
    nvm use default
    has npm || (echo "Npm command not found." && return 1)
  fi
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset ALL_PROXY
  unset http_proxy
  unset https_proxy
  unset all_proxy
  npm install -g npm
  npm install -g fkill-cli
  npm install -g ramda-cli
  npm install -g typescript
  npm install -g eslint
  npm install -g pm2
}

install_exa() {
  install_rust exa
  # local tag=${1:-"latest"}
  # [[ "${tag}" == "-f" ]] && tag="latest" && local force="YES"
  # local result="exa-linux-x86_64-${tag##v}.zip"
  # local url="https://github.com/ogham/exa/releases/download/${tag}/${result}"
  # if [[ "${tag}" == "latest" ]]; then
  # local data="$(get_tag_url "ogham/exa" "${tag}" "exa-linux-x86_64")"
  # url="${data%% *}"
  # tag="${data##* }"
  # if [[ -z "${force}" ]] && check_current_tag "exa" "${tag}"; then
  # return
  # fi
  # result="${result//latest/${tag}}"
  # fi
  # echo "Installing exa ${tag}."
  # local dir="${LIB}/exa"
  # _download "${url}" "${dir}" "${result}"
  # _link "${dir}" "exa"
}

install_go() {
  # GO111MODULE=on go get "github.com/$1@latest"
  ${PM} install -y "${module}"
}

install_baidu() {
  install_go qjfoidnh/BaiduPCS-Go
}

install_glow() {
  install_go glow
}

install_rclone() {
  install_go rclone
}

install_v2sub() {
  install_go ThomasZN/v2sub
}

install_fx() {
  install_go antonmedv/fx
}
