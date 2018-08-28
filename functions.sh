dot=~/.dotfiles

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

del() {
  [[ -e $1 ]] && rm -rf $1
}

bin=~/.bin
mkdir -p $bin

install_dot() {
    if [[ ! -d $dot ]]; then
        git clone https://github.com/mmqmzk/dotfiles.git $dot
    fi
    cd $dot
    git pull
    git submodule update --init
}

install_bat() {
    bat_tag=$1
    if [[ -z $bat_tag ]]; then
        return 1
    fi
    echo "Installing bat $bat_tag"
    BAT=~/.bat
    del $BAT
    mkdir -p $BAT && cd $BAT
    bat_file="bat-${bat_tag}-x86_64-unknown-linux-musl"
    curl $proxy -fsSL "https://github.com/sharkdp/bat/releases/download/${bat_tag}/${bat_file}.tar.gz" > ${bat_file}.tar.gz
    tar -xf ${bat_file}.tar.gz && rm -f ${bat_file}.tar.gz
    bat_bin=$bin/bat
    del $bat_bin
    ln -s $BAT/${bat_file}/bat $bat_bin
}

install_fd() {
    fd_tag=$1
    if [[ -z $fd_tag ]]; then
        return 1
    fi
    echo "Installing fd $fd_tag"
    FD=~/.fd
    del $FD
    mkdir -p $FD && cd $FD
    fd_file="fd-${fd_tag}-x86_64-unknown-linux-musl"
    curl $proxy -fsSL "https://github.com/sharkdp/fd/releases/download/${fd_tag}/${fd_file}.tar.gz" > ${fd_file}.tar.gz
    tar -xf ${fd_file}.tar.gz && rm -f ${fd_file}.tar.gz
    fd_bin=$bin/fd
    del $fd_bin
    ln -s $FD/${fd_file}/fd $fd_bin
}


install_fzf() {
    if [[ -n $1 ]]; then
        install_dot
    fi
    echo "Installing fzf"
    FZF=~/.fzf
    if [[ -e  $dot/fzf ]]; then
        del $FZF
        ln -f -s $dot/fzf $FZF
        bash $FZF/install --all
    fi
}

install_jq() {
    jq_tag=$1
    if [[ -z $jq_tag ]]; then
        return 1
    fi
    echo "Installing jq $jq_tag"
    jq_bin=$bin/jq
    del $jq_bin
    curl $proxy -fsSL "https://github.com/stedolan/jq/releases/download/jq-${jq_tag}/jq-linux64" > $jq_bin
    chmod 755 $jq_bin
}


install_vim() {
    if [[ -n $1 ]]; then
        install_dot
    fi
    echo "Installing vim"
    cd ~
    rm -rf ~/.vim*
    ln -s -f $dot/vim ~/.vim
    bash $dot/vim/install.sh
}
