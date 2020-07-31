__lfd() {
  type="$1"
  shift
  args="$1"
  shift
  for name in "$@"; do
    [ $# -gt 1 ] && echo "${name}:"
    find "$name" -maxdepth 1 -type "$type" \
      | sed -E 's|^\./||;s|/$||;/^\.$/d;s/.+/"\0"/' \
      | xargs -r -n 1 ls --color=auto ${args:+"$args"}
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

export PAGER="less -r"

alias c="cd"
alias h="history"
alias he="head"
alias l="command ls --color=auto -lh"
alias la="command ls --color=auto -lha"
alias le="less -r"
alias lsa="command ls --color=auto -A"
alias lss="command ls --color=auto -lhS"
alias lst="command ls --color=auto -lht"
alias p="ps -ef"
alias s="sudo "
alias t="tail"
alias tf="tail -f"
alias vd="vimdiff"
alias yw="sudo yum info"
