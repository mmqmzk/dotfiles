DOT=~/.dotfiles
BIN=~/.bin

wh() {
  for name in $@
  do
    if which $name &> /dev/null
    then
      echo $name
      return 0
    fi
  done
  return 1
}

has() {
    which $1 &> /dev/null
}

del() {
  [[ -e $1 ]] && rm -rf $1
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
        apt install rust -y
    fi
    if ! has cmake; then
        apt install cmake -y
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
    if ! has jq; then
        apt install jq -y
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
    mv $CHT $BIN
}
