__lfd() {
  type="$1"
  shift
  args="$1"
  shift
  for name in "$@"; do
    if [ $# -gt 1 ]; then
      echo "${name}:"
    fi
    find "${name}" -maxdepth 1 -type "${type}" |
      sed -E 's|^\./||;s|/$||;/^\.$/d;s/.+/"\0"/' |
      xargs -r -n 1 ls --color=auto ${args:+"${args}"}
  done
}

_lfd() {
  t="$1"
  shift
  a="$1"
  shift
  if [ $# -eq 0 ]; then
    __lfd "$t" "$a" .
  else
    __lfd "$t" "$a" "$@"
  fi
}

lf() {
  _lfd f "" "$@"
}

llf() {
  _lfd f -lh "$@"
}

lD() {
  _lfd d -d "$@"
}

lld() {
  _lfd d -lhd "$@"
}

lL() {
  _lfd l "" "$@"
}

llL() {
  _lfd l -lh "$@"
}

export LESS='-P"(%i/%m) ?f%f:-stdin-. ?lt%ltL:-./?dt%dtP:-./?pt%pt:-.\%.?e END" -iwR'

export PAGER="less ${LESS:-"imwR"}}"

alias aac="sudo apt autoclean"
alias aar="sudo apt autoremove"
alias ad="sudo apt update"
alias adg="sudo apt update && sudo apt upgrade"
alias adu="sudo apt update && sudo apt dist-upgrade"
alias ai="sudo apt install"
alias al="apt list"
alias all="apt list --installed"
alias alu="apt list --upgradable"
alias ap="sudo apt purge"
alias ar="sudo apt remove"
alias ari="sudo apt reinstall"
alias as="apt search"
alias au="sudo apt upgrade"
alias aw="apt show"
alias dud="du -h -d 1"
alias g="git"
alias gcmm="git commit -m"
alias gcoc="git checkout console"
alias gsf="git submodule foreach"
alias gsfg="git submodule foreach git"
alias goo="BROWSER=w3m googler -l cn"
alias gpo="git push origin --all"
alias c="cd"
alias h="history"
alias he="head"
alias jc="journalctl -x"
alias jce="journalctl -xe"
alias jcu="journalctl -xe -u"
alias k="kill"
alias l="command ls --color=auto -lh"
alias la="command ls --color=auto -lha"
alias le="less ${LESS:-"imwR"}"
alias lsa="command ls --color=auto -A"
alias lss="command ls --color=auto -lhS"
alias lst="command ls --color=auto -lht"
alias p="ps -ef"
alias par="parallel"
alias pk="pkill"
alias s="sudo "
alias sc-dr="sudo systemctl daemon-reload"
alias t="tail"
alias tf="tail -f"
alias vd="vimdiff"
alias ye="sudo yum erase"
alias yi="sudo yum install"
alias yr="sudo yum erase"
alias yri="sudo yum reinstall"
alias ys="sudo yum search"
alias yu="sudo yum update"
alias yw="sudo yum info"
