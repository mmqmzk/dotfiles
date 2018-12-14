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

version_lte() {
    [[ $1 == $(printf "%s\n%s" $1 $2 | sort -V | head -n 1) ]]
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
    ln -s -f $DOT/sshrc.sh $BIN/sshrc
    ln -s -f $DOT/sshrc.d ~/.sshrc.d
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

install_q() {
    echo "Installing q"
    check_bin
    local Q=$BIN/q
    del $Q
    curl $PROXY -fsSL https://github.com/harelba/q/raw/master/bin/q -o $Q
    chmod 755 $Q
}

install_node() {
    local NVM=${NVM_DIR:="~/.nvm"}"/nvm.sh"
    if [[ -f $NVM ]]; then
        source $NVM
    else
        echo "nvm not installed"
        return 1
    fi
    local CURRENT_VERSION=$(cat ~/.nvmrc)
    local NODE_TAG=${1:="0"}
    if version_lte $NODE_TAG "0"; then
        return 1
    fi
    if [[ $NODE_TAG != $CURRENT_VERSION ]] && nvm version $CURRENT_VERSION &> /dev/null then
        nvm uninstall $CURRENT_VERSION
    fi
    if nvm install $NODE_TAG; then
        echo $NODE_TAG > ~/.nvmrc
        nvm use --delete-prefix $NODE_TAG --silent
        return 0
    fi
    return 1
}
