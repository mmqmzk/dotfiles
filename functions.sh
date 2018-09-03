DOT=~/.dotfiles
BIN=~/.bin

has() {
    which $1 &> /dev/null
}

wh() {
  for name in $@
  do
    if has $name; then
      echo $name
      return 0
    fi
  done
  return 1
}

export PM=$(wh yum apt)

is_debian() {
    [[ $PM != *yum* ]]
}

del() {
  [[ -e $1 || -L $1 ]] && rm -rf $1
}

check_bin() {
    [[ -d $BIN ]] || mkdir -p $BIN
}


install_dot() {
    if [[ ! -d $DOT ]]; then
        git clone https://github.com/mmqmzk/dotfiles.git $DOT
    fi
    cd $DOT
    git pull
    git submodule update --init
    check_bin
    ln -s -f $DOT/zsh-custom/diff-so-fancy/diff-so-fancy $BIN/diff-so-fancy
}

install_rust() {
    if ! has cargo; then
        $PM install rust -y
    fi
    if ! has cmake; then
        $PM install cmake -y
    fi
}

install_bat() {
    install_rust
    cargo install bat -f
}

install_fd() {
    install_rust
    cargo install fd-find -f
}


install_fzf() {
    if [[ $1 == "init" ]]; then
        install_dot
    fi
    if [[ -e  $DOT/fzf ]]; then
        echo "Installing fzf"
        check_bin
        local FZF=~/.fzf
        del $FZF
        ln -f -s $DOT/fzf $FZF
        del $DOT/fzf/bin/fzf
        bash $FZF/install --all
    fi
}

install_jq() {
    if is_debian; then
        $PM install jq -y
    else
        local JQ_TAG=$1
        if [[ -z $JQ_TAG ]]; then
            return 1
        fi
        echo "Installing jq $JQ_TAG"
        check_bin
        local JQ_BIN=$BIN/jq
        del $JQ_BIN
        curl $PROXY -fsSL "https://github.com/stedolan/jq/releases/download/jq-${JQ_TAG}/jq-linux64" > $JQ_BIN
        chmod 755 $JQ_BIN
    fi
}


install_vim() {
    if [[ $1 == "init" ]]; then
        install_dot
    fi
    echo "Installing vim"
    cd ~
    rm -rf ~/.vim*
    local VIMDIR=$DOT/vim
    ln -s -f $VIMDIR ~/.vim
    bash $VIMDIR/install.sh
}

install_cht() {
    echo "Installing cheat.sh"
    check_bin
    local CHT=/tmp/cht
    del $CHT
    curl $PROXY -sSfL http://cht.sh/:cht.sh > $CHT
    chmod 755 $CHT
    del $BIN/cht
    mv -f $CHT $BIN
}

install_rg() {
    install_rust
    cargo install ripgrep -f
}
