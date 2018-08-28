#!/usr/bin/env bash
proxy=$@
cd $(dirname $0)
source ./functions.sh

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

install_dot

omz=$dot/oh-my-zsh
zrc=~/.zshrc
del $zrc
echo "Oh my zsh"
ln -s -f $dot/zshrc $zrc

echo "Zsh plugins and themes"
themes=$dot/zsh-custom/
mkdir -p $themes && cd $themes
awk '/^prompt_context/{a=NR} {if(a>0&&NR>a&&NR<a+4)$0="#"$0;print}' $omz/themes/agnoster.zsh-theme > agnoster.zsh-theme

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
ln -s -f $dot/nvm $NVM

echo "Git config"
GC=~/.gitconfig
del $GC
ln -s -f $dot/gitconfig  $GC

echo "Cheat.sh"
CHT=/tmp/cht
del $CHT
curl $proxy -sSfL http://cht.sh/:cht.sh > $CHT
chmod 755 $CHT
del $bin/cht
mv $CHT $bin

install_bat "v0.5.0"

install_fd "v7.1.0"

install_fzf

install_jq "1.5"

install_vim
