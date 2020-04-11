__lfd() {
  type="$1"
  shift
  args="$1"
  shift
  for name in "$@"; do
    [ $# -gt 1 ] && echo "${name}:"
    find "$name" -maxdepth 1 -type "$type" \
      | sed -E 's|^\./||;s|/$||;/^\.$/d' \
      | xargs -n 1 ls --color=auto ${args:+"$args"}
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
