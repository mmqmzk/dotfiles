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
    curl $PROXY -fsSL "https://github.com/sharkdp/bat/releases/download/${BAT_TAG}/${BAT_FILE}.tar.gz" > ${BAT_FILE}.tgz
    tar -xf ${BAT_FILE}.tgz && rm -f ${BAT_FILE}.tgz
    local BAT_BIN=$BIN/bat
    del $BAT_BIN
    ln -s -f $BAT/${BAT_FILE}/bat $BAT_BIN
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
    local FD_FILE="fd-${FD_TAG}-x86_64-unknown-linux-musl"
    curl $PROXY -fsSL "https://github.com/sharkdp/fd/releases/download/${FD_TAG}/${FD_FILE}.tar.gz" > ${FD_FILE}.tgz
    tar -xf ${FD_FILE}.tgz && rm -f ${FD_FILE}.tgz
    local FD_BIN=$BIN/fd
    del $FD_BIN
    ln -s -f $FD/${FD_FILE}/fd $FD_BIN
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

install_q() {
    echo "Installing q"
    check_bin
    local Q=$BIN/q
    del $Q
    curl $PROXY -fsSL https://github.com/harelba/q/raw/master/bin/q -o $Q
    chmod 755 $Q
}
