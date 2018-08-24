#!/bin/bash
proxy=$@

WH="which --skip-alias"
if ! $WH sh &> /dev/null
then
  WH="command -v"
fi

wh() {
  for name in $@
  do
    program=$($WH $name 2> /dev/null)
    if [[ -x  $program ]]
    then
      echo $program
      return 0
    fi
  done
  return 1
}

del() {
  [[ -e $1 ]] && rm -rf $1
}

YUM=$(wh yum)
APT=$(wh apt)
if [[ -x  $YUM ]]
then
  PM=$YUM
  AG="the_silver_searcher"
elif [[ -x $APT ]]
then
  PM=$APT
  sudo $APT update
  AG="silversearcher-ag"
  if [[ ! -x $(wh jq) ]]
  then
      echo "Jq"
      sudo $PM install jq -y
  fi
else
  echo "yum and apt not found"
  exit 1
fi

if [[ ! -x $(wh git) ]]
then
  echo "Git"
  sudo $PM install git -y
fi
dot=~/.dotfiles
del $dot
git clone https://github.com/mmqmzk/dotfiles.git $dot
cd $dot 
git submodule init
git submodule update

PY=$(wh python3 python)
if [[ -x $PY ]]
then
    PIP=$(wh pip3 pip) 
    if [[ ! -x $PIP ]]
    then
      echo "Pip"
      gpy="/tmp/get-pip.py"
      del $gpy
      curl $proxy -sSfL https://bootstrap.pypa.io/get-pip.py > $gpy
      $PY $gpy
    fi
    $PIP install pip -U 
    echo "Httpie"
    $PIP install httpie -U 
fi

if [[ ! -x $(wh ag) ]]
then
  echo "Ag"
  sudo $PM install $AG -y
fi

if [[ ! -x $(wh zsh) ]] 
then
  echo "Zsh"
  sudo $PM install zsh -y
fi

omz=$dot/oh-my-zsh
zrc=~/.zshrc
del $zrc
echo "Oh my zsh"
ln -s -f $dot/zshrc $zrc
#bash -c "$(curl $proxy -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/env zsh/d')"

echo "Zsh plugins and themes"
#plugins=$omz/custom/plugins
#mkdir -p $plugins && cd $plugins
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#git clone https://github.com/zsh-users/zsh-autosuggestions.git
#git clone https://github.com/changyuheng/fz.git
themes=$dot/zsh-custom/
mkdir -p $themes && cd $themes
awk '/^prompt_context/{a=NR} {if(a>0&&NR>a&&NR<a+4)$0="#"$0;print}' $omz/themes/agnoster.zsh-theme > agnoster.zsh-theme
#curl $proxy -fsSL https://gist.github.com/mmqmzk/ae92f25a1d506ba0235a79619f9aceb1/raw/09a5844181a87dc93ba1590b368ac52b7c539b33/.zshrc > $zrc

echo "Tmux"
if [[ ! -x $(wh tmux) ]]
then
    sudo $PM install tmux -y
fi
tc=~/.tmux.conf
del $tc
ln -s -f $dot/tmux.conf $tc

echo "Nvm"
NVM=~/.nvm
del $NVM
#git clone https://github.com/creationix/nvm.git $NVM
ln -s -f $dot/nvm $NVM

echo "Git config"
GC=~/.gitconfig
del $GC
#curl $proxy -sSfL https://gist.github.com/mmqmzk/0dd992e46f4b54136e26f4a87343d01f/raw/0ea1fc834e58e6e1c19a13cd1d0f1b75c5004ff8/.gitconfig > $GC
ln -s -f $dot/gitconfig  $GC

bin=~/.bin
mkdir -p $bin

echo "Cheat.sh"
CHT=/tmp/cht
del $CHT
curl $proxy -sSfL http://cht.sh/:cht.sh > $CHT
chmod 755 $CHT
del $bin/cht
mv $CHT $bin

echo "Bat"
BAT=~/.bat
del $BAT
mkdir -p $BAT && cd $BAT
bat_tag="v0.5.0"
bat_file="bat-${bat_tag}-x86_64-unknown-linux-musl"
curl $proxy -fsSL "https://github.com/sharkdp/bat/releases/download/${bat_tag}/${bat_file}.tar.gz" > ${bat_file}.tar.gz
tar -xf ${bat_file}.tar.gz && rm -f ${bat_file}.tar.gz
bat_bin=$bin/bat
del $bat_bin
ln -s $BAT/${bat_file}/bat $bat_bin

echo "Fd"
FD=~/.fd
del $FD
mkdir -p $FD && cd $FD
fd_tag="v7.1.0"
fd_file="fd-${fd_tag}-x86_64-unknown-linux-musl"
curl $proxy -fsSL "https://github.com/sharkdp/fd/releases/download/${fd_tag}/${fd_file}.tar.gz" > ${fd_file}.tar.gz
tar -xf ${fd_file}.tar.gz && rm -f ${fd_file}.tar.gz
fd_bin=$bin/fd
del $fd_bin
ln -s $FD/${fd_file}/fd $fd_bin


echo "Fzf"
FZF=~/.fzf
del $FZF
#git clone https://github.com/junegunn/fzf.git $FZF
ln -f -s $dot/fzf $FZF
bash $FZF/install --all

if [[ ! -x $(wh jq) ]]
then
    echo "Jq"
    jq_tag="1.5"
    jq_bin=$bin/jq
    del $jq_bin
    curl $proxy -fsSL "https://github.com/stedolan/jq/releases/download/jq-${jq_tag}/jq-linux64" > $jq_bin
    chmod 755 $jq_bin
fi


echo "Vim"
cd ~
rm -rf ~/.vim*
#git clone https://github.com/mmqmzk/.vim.git
#cd .vim && bash install.sh
ln -s -f $dot/vim ~/.vim
bash $dot/vim/install.sh
