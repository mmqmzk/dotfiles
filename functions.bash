DOT=${DOT:-"$HOME/.dotfiles"}
BIN=${BIN:-"$HOME/.local/bin"}
LIB=${LIB:-"$HOME/.local/lib"}

RUST_ARCH="x86_64-unknown-linux-musl"

has() {
  wh "$@" &> /dev/null
}

wh() {
  for name in "$@"; do
    command which "$name" 2> /dev/null && return
  done
  return 1;
}
PM=$(wh yum apt)
export PM

is_debian() {
  [[ "$PM" != *yum* ]]
}

del() {
  for file in "$@"; do
    ([[ -e "$file" || -L "$file" ]] \
      && mv --backup=t "$1" /tmp &> /dev/null) \
      || rm -rf "$file" &> /dev/null
  done
}

version_lte() {
  [[ "$1" == "$(printf "%s\n%s" "$1" "$2" | sort -V | head -n 1)" ]]
}

check_bin() {
  [[ -d "$BIN" ]] || mkdir -p "$BIN"
  [[ -d "$LIB" ]] || mkdir -p "$LIB"
}


install_dot() {
  if [[ ! -d "$DOT" ]]; then
    git clone git@github.com:mmqmzk/dotfiles.git "$DOT" \
      || git clone https://github.com/mmqmzk/dotfiles.git "$DOT"
  fi
  pushd "$DOT" &> /dev/null
  git pull
  git submodule update --init
  check_bin
  ln -sf "$DOT/zsh-custom/diff-so-fancy/diff-so-fancy" "$BIN/diff-so-fancy"
  ln -sf "$DOT/zfuncs/sshrc" "$BIN/sshrc"
  ln -sf "$DOT/zfuncs/v" "$BIN/v"
  ln -sf "$DOT/sshrc.d" ~/.sshrc.d
  if [[ "$HOME" != /root ]]; then
    sudo mkdir -p /root/.local
    sudo ln -s "$BIN" /root/.local/bin
    sudo ln -s "$DOT/zfuncs/v" /usr/local/bin
  fi
  popd
}

add_v() {
  : "$1"
  [[ "$2" == v* ]] && [[ "$_" != v* ]] &&: "v${_}"
  [[ "$2" == V* ]] && [[ "$_" != V* ]] && : "V${_}"
  echo "$_"
}

check_current_tag() {
  : "$("$1" --version 2>&1 | grep -iv "command not found" \
    | grep -v '未找到命令' | grep -Eio 'v?[0-9]+[0-9.]*' | sed '1q')"
  : "$(add_v "$_" "$2")"
  [[ -n "$_" ]] && version_lte "$2" "$_" \
    && echo "Tool $1 already up to date, version: $_."
}

get_tag_url() {
  has jq || (echo "Tool jq not Installed." && exit 1)
  curl -fsSL "https://api.github.com/repos/$1/releases/${2:-latest}" \
    | jq "{url:.assets[].browser_download_url,tag:.tag_name}\
    |select(.url|contains(\"${3:-$RUST_ARCH}\"))|.url+\" \"+.tag" -r | sed '1q'
}

download() {
  local url="$1"
  local dir="$2"
  local result="$3"
  del "$dir"
  mkdir -p "$dir" && pushd "$dir" &> /dev/null
  curl -fsSL "$url" -o "$result"
  case "$result" in
    *.tar.*|*.tar)
      tar -xf "$result" && del "$result"
      ;;
    *.zip)
      zip -o "$result" && del "$result"
      ;;
  esac
  popd &> /dev/null
}

_link() {
  check_bin
  : "$(find "$1" -name "*${2}*" -type f  -perm -555 | sed '1q')"
  ln -sf "$_" "$BIN/$2"
  : "$(ls -l --color=always "$_")"
  echo "Linked $_."
  : "$(find "$1" -name "*.1" -type f)"
  ([[ -n "$_" ]] && (echo "$_" \
    | xargs -I{} sudo cp -f "{}" /usr/local/share/man/man1) \
    && sudo mandb) || true
}

install_rust_module() {
  local module=$1
  local bin=$2
  local repo=$3
  local tag=${4:-latest}
  [[ "$tag" == "-f" ]] && tag="latest" && local force="YES"
  local arch=${5:-$RUST_ARCH}
  local url=
  local result="$module-$tag-$arch.tar.gz"
  if [[ "$tag" == "latest" ]]; then
    local data="$(get_tag_url "$repo" "$tag" "$arch")"
    url="${data%% *}"
    tag="${data##* }"
    [[ -z "$force" ]] && check_current_tag "$bin" "$tag" && return
    result="${result//latest/$tag}"
  else
    url="https://github.com/$repo/releases/download/$tag/$result"
  fi
  echo "Installing $module $tag."
  local dir="$LIB/$module"
  download "$url" "$dir" "$result"
  _link "$dir" "$bin"
}

install_bat() {
  install_rust_module bat bat "sharkdp/bat" "$1"
}

install_fd() {
  install_rust_module fd fd "sharkdp/fd" "$1"
}

install_ripgrep() {

  install_rust_module ripgrep rg "BurntSushi/ripgrep" "$1"
}

install_xsv() {
  install_rust_module xsv "xsv" "BurntSushi/xsv" "$1"
}

install_lsd() {
  install_rust_module lsd lsd "Peltoche/lsd" "${1:-latest}" x86_64-unknown-linux-gnu
}


install_fzf() {
  if [[ $1 == "init" ]]; then
    install_dot
  fi
  if [[ -f "$DOT/fzf/install" ]]; then
    echo "Installing fzf."
    bash "$DOT/fzf/install" --bin
    ln -sf "$DOT/fzf/bin/fzf" "$BIN"
    sudo cp -rf "$DOT/fzf/man/man1" /usr/share/man
    sudo mandb
  fi
}

install_jq() {
  if is_debian; then
    sudo ${PM} install jq jo -y
  else
    local JQ_TAG=$1
    [[ -z "$JQ_TAG" ]] && return 1
    echo "Installing jq $JQ_TAG"
    local result="jq-linux64"
    local dir="$LIB/jq"
    : "https://github.com/stedolan/jq/releases/download/jq-$JQ_TAG/$result"
    download  "$_" "$dir" "$result"
    chmod 755 "$dir/$result"
    _link "$dir" "jq"
  fi
}


install_vim() {
  if [[ $1 == "init" ]]; then
    install_dot
  fi
  echo "Installing vim"
  pushd ~ &> /dev/null
  del ~/.vim*
  local VIMDIR="$DOT/vim"
  ln -sf "$VIMDIR" ~/.vim
  bash "$VIMDIR/install.sh"
  popd &> /dev/null
}

install_cht() {
  echo "Installing cheat.sh"
  check_bin
  : "/tmp/cht"
  del "$_"
  curl -sSfL http://cht.sh/:cht.sh -o "$_"
  chmod 755 "$_"
  mv -f "$_" "$BIN"
}

install_q() {
  local tag=${1:-latest}
  [[ "$tag" == "-f" ]] && tag="latest" && local force="YES"
  local result="q-x86_64-Linux"
  local url="https://github.com/harelba/q/releases/download/$tag/$result"
  if [[ "$tag" == "latest" ]]; then
    local data="$(get_tag_url "harelba/q" "$tag" "$result")"
    url="${data%% *}"
    tag="${data##* }"
    [[ -z "$force" ]] && check_current_tag "q" "$tag" && return
    result="${result//latest/$tag}"
  fi
  echo "Installing q $tag."
  local dir="$LIB/q"
  download "$url" "$dir" "$result"
  chmod 755 "$dir/$result"
  _link "$dir" "q"
}

install_node() {
  : "${NVM_DIR:-"$DOT/nvm"}/nvm.sh"
  if [[ -f "$_" ]]; then
    source "$_"
  else
    echo "Tool nvm not installed."
    return 1
  fi
  local NVMRC="$HOME/.nvmrc"
  local CURRENT_VERSION="$(nvm current 2> /dev/null)"
  local NODE_TAG="$(nvm ls-remote "$1" 2> /dev/null | grep -Eo 'v[0-9.]+' | sort -V | tail -n 1)"
  [[ -z "$NODE_TAG" ]] && echo "Node version $1 not found." && return 1
  if [[ "$NODE_TAG" != "$CURRENT_VERSION" ]]; then
    if nvm install "$NODE_TAG"; then
      echo "$NODE_TAG" > "$NVMRC"
      nvm alias default "$NODE_TAG"
      nvm use --delete-prefix default
      install_npm
    else
      echo "Install node version $NODE_TAG failed."
      return 1
    fi
    if nvm version "$CURRENT_VERSION" &> /dev/null; then
      nvm uninstall "$CURRENT_VERSION"
    fi
  else
    echo "Node version $NODE_TAG alreday installed."
  fi
}


install_npm() {
  if ! has npm; then
    nvm use default
    has npm || (echo "Npm command not found." && return 1)
  fi
  npm install -g npm
  npm install -g fkill-cli
  npm install -g ramda-cli
  npm install -g typescript
  npm install -g eslint
}


install_exa() {
  local tag=${1:-latest}
  [[ "$tag" == "-f" ]] && tag="latest" && local force="YES"
  local url="https://github.com/ogham/exa/releases/download/$tag/$file"
  local result="exa-linux-x86_64-$tag.zip"
  if [[ "$tag" == "latest" ]]; then
    local data="$(get_tag_url "ogham/exa" "$tag" "exa-linux-x86_64")"
    url="${data%% *}"
    tag="${data##* }"
    [[ -z "$force" ]] && check_current_tag "exa" "$tag" && return
    result="${result//latest/$tag}"
  fi
  echo "Installing exa $tag."
  local dir="$LIB/exa"
  download "$url" "dir" "$result"
  _link "$dir" "exa"
}

