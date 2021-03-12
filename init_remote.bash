#!/usr/bin/env bash

user=root
group=root
while [[ -n "$1" ]]; do
  case "$1" in
    -u)
      user="$2"
      shift
      ;;
    -g)
      group="$2"
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
eval "base=~${user}"
BASE=${BASE:-"${base}"}
DOT=${DOT:-"${BASE}/.dotfiles"}
LOCAL=${LOCAL:-"${BASE}/.local"}
BIN="${LOCAL}/bin"
LIB="${LOCAL}/lib"
DOT_BALL="${DOT_BALL:-"${HOME}/dot.tbz2"}"

del() {
   (mv -f --backup=t -t /tmp "$@" \
     || rm -rf "$@") \
     || (sudo mv -f --backup=t -t /tmp "$@" \
     || sudo rm -rf "$@")
}

rm -rf "${DOT}" "${LOCAL}"
del "${BASE}/.vim"
del "/root/.vim"
find "${BASE}" -maxdepth 1 -type l -delete
tar -xf "${DOT_BALL}" -C "${BASE}"

_chown() {
  if [[ "$(stat -c "%U" "$1")" != "${user}" ]] \
    || [[ "$(stat -c "%G" "$1")" != "${group}" ]]; then
    local -a cmd
    cmd=("chown" "${user}:${group}" "-R")
    if [[ "${user}" != "${USER}" ]]; then
      cmd=("sudo" "${cmd[@]}")
    fi
    "${cmd[@]}" "$1"
  fi
}

_chown "${DOT}"
_chown "${LOCAL}"
chmod -R go-w "${DOT}"
ln -sfn "${DOT}/zshrc"  "${BASE}/.zshrc"
# ln -sfn "${DOT}/vim"  "${BASE}/.vim"
ln -sfn "${DOT}/sshrc.d/vimrc" "${BASE}/.vimrc"
if [[ "${user}" != "root" ]]; then
  sudo ln -sfn "${BASE}/.vimrc" /root
fi
ln -sfn "${DOT}/zsh-custom/diff-so-fancy/diff-so-fancy" "${BIN}"
ln -sfn "${DOT}/gitconfig" "${BASE}/.gitconfig"

if [[ -e /root/.local/bin ]]; then
  sudo bash -c "mkdir -p /root/.local && ln -s '${BIN}' /root/.local/bin"
fi

_link() {
  find "${LIB}" -type f -perm -500 -name "$1" -exec ln -sfn {} "${BIN}/$2" \;
}

_link bat bat
_link fd fd
_link rg rg
_link xsv xsv

if [[ -n "${EXA}" ]]; then
  _link exa-linux-x86_64 ${EXA}
fi
if [[ -n "${LSD}" ]]; then
  _link lsd ${LSD}
fi
