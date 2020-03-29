DOT=${DOT:-"$HOME/.dotfiles"}
BIN=${BIN:-"$HOME/.local/bin"}
LIB=${LIB:-"$HOME/.local/lib"}

RUST_ARCH="x86_64-unknown-linux-musl"

has() {
  wh $@ &> /dev/null
}

wh() {
  for name in $@
  do
    command which $name 2> /dev/null && return 0
  done
  return 1;
}

export PM=$(wh yum apt)

is_debian() {
  [[ "$PM" != *yum* ]]
}

del() {
  for file in "$@"; do
    [[ -e "$file" || -L "$file" ]] && mv --backup=t "$1" /tmp || true
  done
}

version_lte() {
  [[ "$1" == "$(printf "%s\n%s" $1 $2 | sort -V | head -n 1)" ]]
}

check_bin() {
  [[ -d "$BIN" ]] || mkdir -p "$BIN"
  [[ -d "$LIB" ]] || mkdir -p "$LIB"
}


install_dot() {
  if [[ ! -d "$DOT" ]]; then
    git clone https://github.com/mmqmzk/dotfiles.git "$DOT"
  fi
  cd "$DOT"
  git pull
  git submodule update --init
  check_bin
  ln -s -f "$DOT/zsh-custom/diff-so-fancy/diff-so-fancy" "$BIN/diff-so-fancy"
  ln -s -f "$DOT/zfuncs/sshrc" "$BIN/sshrc"
  ln -s -f "$DOT/zfuncs/v" "$BIN/v"
  ln -s -f "$DOT/sshrc.d" ~/.sshrc.d
  if [[ "$HOME" != /root ]]; then
    sudo mkdir -p /root/.local
    sudo ln -s $BIN /root/.local/bin
    sudo ln -s "$DOT/zfuncs/v" /usr/local/bin
  fi
}

install_rust_module() {
  local module=$1
  local bin=$2
  local repo=$3
  local tag=$4
  local arch=${5:-$RUST_ARCH}
  if [[ -z "$tag" ]]; then
    return 1
  fi
  echo "Installing $module $tag"
  check_bin
  local dir="$LIB/$module"
  del "$dir"
  mkdir -p "$dir" && cd "$dir"
  local file="$module-$tag-$arch"
  curl -fsSL "https://github.com/$repo/releases/download/$tag/$file.tar.gz" > "$file.tgz"
  tar -xf "$file.tgz" && rm -f "$file.tgz"
  if [[ $bin == /* ]]; then
    ln -s -f "$dir$bin" "$BIN/$(basename $bin)"
  else
    ln -s -f "$dir/$file/$bin" "$BIN/$(basename $bin)"
  fi
}

install_bat() {
  install_rust_module bat bat "sharkdp/bat" $1
}

install_fd() {
  install_rust_module fd fd "sharkdp/fd" $1
}

install_ripgrep() {
  install_rust_module ripgrep rg "BurntSushi/ripgrep" $1
}

install_xsv() {
  install_rust_module xsv "/xsv" "BurntSushi/xsv" $1
}

install_lsd() {
  install_rust_module lsd lsd "Peltoche/lsd" $1 x86_64-unknown-linux-gnu
}


install_fzf() {
  if [[ $1 == "init" ]]; then
    install_dot
  fi
  if [[ -f  "$DOT/fzf/install" ]]; then
    echo "Installing fzf"
    bash "$DOT/fzf/install" --bin
    ln -s -f $DOT/fzf/bin/fzf $BIN
  fi
}

install_jq() {
  if is_debian; then
    sudo ${PM} install jq jo -y
  else
    local JQ_TAG=$1
    if [[ -z "$JQ_TAG" ]]; then
      return 1
    fi
    echo "Installing jq $JQ_TAG"
    check_bin
    local JQ_BIN="$BIN/jq"
    del "$JQ_BIN"
    curl -fsSL "https://github.com/stedolan/jq/releases/download/jq-$JQ_TAG/jq-linux64" > "$JQ_BIN"
    chmod 755 "$JQ_BIN"
  fi
}


install_vim() {
  if [[ $1 == "init" ]]; then
    install_dot
  fi
  echo "Installing vim"
  cd ~
  del ~/.vim*
  local VIMDIR="$DOT/vim"
  ln -s -f $VIMDIR ~/.vim
  bash "$VIMDIR/install.sh"
}

install_cht() {
  echo "Installing cheat.sh"
  check_bin
  local CHT="/tmp/cht"
  del "$CHT"
  curl -sSfL http://cht.sh/:cht.sh -o "$CHT"
  chmod 755 "$CHT"
  del "$BIN/cht"
  mv -f "$CHT" "$BIN"
}

install_q() {
  echo "Installing q"
  check_bin
  local Q="$BIN/q"
  del "$Q"
  curl -fsSL https://github.com/harelba/q/raw/master/bin/q -o "$Q"
  chmod 755 "$Q"
}

install_node() {
  local NVM="${NVM_DIR:-"$DOT/nvm"}/nvm.sh"
  if [[ -f "$NVM" ]]; then
    source "$NVM"
  else
    echo "nvm not installed"
    return 1
  fi
  local NVMRC="$HOME/.nvmrc"
  local CURRENT_VERSION="$(nvm current 2> /dev/null)"
  local NODE_TAG="$(nvm ls-remote $1 2> /dev/null | egrep -o 'v[0-9.]+' | sort -V | tail -n 1)"
  if [[ -z "$NODE_TAG" ]]; then
    echo "Node version $1 not found"
    return 1
  fi
  if [[ "$NODE_TAG" != "$CURRENT_VERSION" ]]; then
    if nvm install ${NODE_TAG}; then
      echo ${NODE_TAG} > "$NVMRC"
      nvm alias default ${NODE_TAG}
      nvm use --delete-prefix default
      install_npm
    else
      echo "Install node version $NODE_TAG failed"
      return 1
    fi
    if nvm version ${CURRENT_VERSION} &> /dev/null; then
      nvm uninstall ${CURRENT_VERSION}
    fi
  else
    echo "Node version $NODE_TAG alreday installed"
  fi
}


install_npm() {
  if ! has npm; then
    nvm use default
    if ! has npm; then
      echo "npm command not found"
      return 1
    fi
  fi
  npm install -g npm
  npm install -g fkill-cli
  npm install -g ramda-cli
}


install_exa() {
  local tag=$1
  if [[ -z "$tag" ]]; then 
    return 1
  fi
  echo "Installing exa"
  local EXA="$LIB/exa"
  mkdir -p "$EXA" && pushd "$EXA"
  local file="exa-linux-x86_64-$tag.zip"
  local url="https://github.com/ogham/exa/releases/download/v$tag/$file"
  curl -fsSL $url -o "$file"
  unzip -o "$file" 
  ln -sf "$EXA/exa-linux-x86_64" "$BIN/exa"  
  rm -f "$file"
  popd
}
