#!/usr/bin/env zsh
DOT=${DOT:-~/.dotfiles}
TMP=$DOT/tmp

local hosts=()
local opts=()
local port=22
local remoteOpts=()
while [[ -n "$1" ]]; do
  case "$1" in
    -h)
      echo "Usage:\n\
    $0 [-u USER] [-g GROUP] [-i ssh_privkey_file] \
[(-p|-P) ssh_port] [-o ssh_option] host...\n\
    use -u and -g to specify USER and GROUP on target host
    use -e to install exa, -l to install lsd
      "
      exit 0
      ;;
    -p|-P)
      port=$2
      shift
      ;;
    -i|-o)
      opts=($opts $1 $2)
      shift
      ;;
    -u|-g)
      remoteOpts=($remoteOpts $1 $2)
      shift
      ;;
    -e|-l)
      remoteOpts=($remoteOpts $1)
      ;;
    -*)
      ;;
    *)
      hosts=($hosts $1)
      ;;
  esac
  shift
done

pushd $TMP
for host in $hosts; do
  if [[ -n "$host" ]]; then
    if [[ "$host" !=  *@* ]]; then
      host="root@$host"
    fi
    scp -P $port $opts dot.tbz2 $host:~
    cat $DOT/init_remote.bash | ssh -p $port $opts $host "bash -s -- $remoteOpts"
  fi
done
popd
