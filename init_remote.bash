#!/usr/bin/env bash
user=root
group=root
while [[ -n "$1" ]]; do
  case "$1" in
    -u)
      user=$2
      shift
      ;;
    -g)
      group=$2
      shift
      ;;
    -e)
      EXA="exa"
      ;;
    -l)
      LSD="lsd"
      ;;
  esac
  shift
done
eval "base=~$user"
BASE=${BASE:-$base}
DOT=${DOT:-$BASE/.dotfiles}
LOCAL=${LOCAL:-$BASE/.local}
BIN=$LOCAL/bin
LIB=$LOCAL/lib
DOT_BALL=${DOT_BALL:-$HOME/dot.tbz2}

rm -rf $DOT $LOCAL
find $BASE -maxdepth 1 -type l -delete
tar -xf $DOT_BALL -C $BASE

_chown() {
  if [[ $(stat -c "%U" $1) != "$user" ]] || [[ $(stat -c "%G" $1) != "$group" ]]; then
    local cmd="chown $user:$group -R"
    if [[ "$user" != "$USER" ]]; then
      cmd="sudo $cmd"
    fi
    $cmd $1
  fi
}

_chown $DOT
_chown $LOCAL
chmod -R go-w .dotfiles
ln -sf $DOT/zshrc  $BASE/.zshrc
ln -sf $DOT/vim  $BASE/.vim
ln -sf $DOT/zsh-custom/diff-so-fancy/diff-so-fancy $BIN
ln -sf $DOT/sshrc.d  $BASE/.sshrc.d
ln -sf $DOT/gitconfig $BASE/.gitconfig

sudo rm -f /usr/local/bin/v
echo "alias v=vim" >> $HOME/.zprofile
#sudo ln -s $DOT/zfuncs/v /usr/local/bin/v

if [[ ! -e /root/.local/bin ]]; then
  mkdir -p /root/.local
  sudo ln -s $BIN /root/.local/bin
fi

_link() {
  find $LIB -type f -perm -500 -name "$1" -exec ln -sf {} $BIN/$2 \;
}

_link bat bat
_link fd fd
_link rg rg
_link xsv xsv

if [[ -n "$EXA" ]]; then
  _link exa-linux-x86_64 $EXA
fi

if [[ -n "$LSD" ]]; then
  _link lsd $LSD
fi
