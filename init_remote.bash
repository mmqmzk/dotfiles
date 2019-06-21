#!/usr/bin/env bash
U=root
G=root
while [[ -n "$1" ]]; do
  case "$1" in
    -u)
      U=$2
      shift
      ;;
    -g)
      G=$2
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
eval "H=${H:-~$U}"
DOT=${DOT:-$H/.dotfiles}
LOCAL=${LOCAL:-$H/.local}
BIN=$LOCAL/bin
LIB=$LOCAL/lib
DOT_BALL=${DOT_BALL:-$HOME/dot.tbz2}

rm -rf $DOT $LOCAL
find $H -maxdepth 1 -type l -delete
tar -xf $DOT_BALL -C $H

changeOnwer() {
  if [[ $(stat -c "%U" $1) != "$U" ]] || [[ $(stat -c "%G" $1) != "$G" ]]; then
    local cmd="chown $U:$G -R"
    if [[ "$U" != "$USER" ]]; then
      cmd="sudo $cmd"
    fi
    $cmd $1
  fi
}

changeOnwer $DOT
changeOnwer $LOCAL
chmod -R go-w .dotfiles
ln -sf $DOT/zshrc  $H/.zshrc
ln -sf $DOT/vim  $H/.vim
ln -sf $DOT/zsh-custom/diff-so-fancy/diff-so-fancy $BIN
ln -sf $DOT/sshrc.d  $H/.sshrc.d
ln -sf $DOT/gitconfig $H/.gitconfig
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
