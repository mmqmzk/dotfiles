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

install_bat() {
    local BAT_TAG=$1
    if [[ -z $BAT_TAG ]]; then
        return 1
    fi
    echo "Installing bat $BAT_TAG"
    check_bin
    local BAT=~/.bat
    del $BAT
    mkdir -p $BAT && cd $BAT
    local BAT_FILE="bat-${BAT_TAG}-x86_64-unknown-linux-musl"
    curl $PROXY -fsSL "https://github.com/sharkdp/bat/releases/download/${BAT_TAG}/${BAT_FILE}.tar.gz" > ${BAT_FILE}.tar.gz
    tar -xf ${BAT_FILE}.tar.gz && rm -f ${BAT_FILE}.tar.gz
    local BAT_BIN=$BIN/bat
    del $BAT_BIN
    ln -s $BAT/${BAT_FILE}/bat $BAT_BIN
}

install_fd() {
    local FD_TAG=$1
    if [[ -z $FD_TAG ]]; then
        return 1
    fi
    echo "Installing fd $FD_TAG"
    check_bin
    local FD=~/.fd
    del $FD
    mkdir -p $FD && cd $FD
    local FD_FILE="fd-${FD_TAG}-x86_64-unknown-linux-musl.tar.gz"
    curl $PROXY -fsSL "https://github.com/sharkdp/fd/releases/download/${FD_TAG}/${FD_FILE}.tar.gz" > ${FD_FILE}
    tar -xf ${FD_FILE}.tar.gz && rm -f ${FD_FILE}.tar.gz
    local FD_BIN=$BIN/fd
    del $FD_BIN
    ln -s $FD/${FD_FILE}/fd $FD_BIN
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
}


install_vim() {
    if [[ $1 == "init" ]]; then
        install_dot
    fi
    echo "Installing vim"
    cd ~
    rm -rf ~/.vim*
    local VIMDir=$DOT/vim
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
