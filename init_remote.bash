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

rm -rf "$DOT" "$LOCAL"
: "$BASE/.vim" && [[ -e "$_" || -L "$_" ]] && rm -rf "$_"
: "/root/.vim" && [[ -e "$_" || -L "$_" ]] && sudo rm -rf "$_"
find "$BASE" -maxdepth 1 -type l -delete
tar -xf "$DOT_BALL" -C "$BASE"

_chown() {
  if [[ $(stat -c "%U" "$1") != "$user" ]] || [[ $(stat -c "%G" "$1") != "$group" ]]; then
    local cmd="chown $user:$group -R"
    if [[ "$user" != "$USER" ]]; then
      cmd="sudo $cmd"
    fi
    $cmd "$1"
  fi
}

_chown "$DOT"
_chown "$LOCAL"
chmod -R go-w "$DOT"
ln -sfn "$DOT/zshrc"  "$BASE/.zshrc"
# ln -sfn "$DOT/vim"  "$BASE/.vim"
ln -sfn "$DOT/sshrc.d/vimrc" "$BASE/.vimrc"
[[ "$user" != "root" ]] && sudo ln -sfn "$BASE/.vimrc" /root
ln -sfn "$DOT/zsh-custom/diff-so-fancy/diff-so-fancy" "$BIN"
ln -sfn "$DOT/gitconfig" "$BASE/.gitconfig"

[[ -e /root/.local/bin ]] \
  || sudo bash -c "mkdir -p /root/.local && ln -s '$BIN' /root/.local/bin"

_link() {
  find "$LIB" -type f -perm -500 -name "$1" -exec ln -sfn {} "$BIN/$2" \;
}

_link bat bat
_link fd fd
_link rg rg
_link xsv xsv

[[ -n "$EXA" ]] && _link exa-linux-x86_64 $EXA
[[ -n "$LSD" ]] && _link lsd $LSD
