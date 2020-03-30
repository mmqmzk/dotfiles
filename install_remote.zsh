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
      cat <<- 'EOF'
			Usage:
			  $0 [-u USER] [-g GROUP] [-i ssh_privkey_file] \
			    [(-p|-P) ssh_port] [-o ssh_option] host...\
			  use -u and -g to specify USER and GROUP on target host
			  use -e to install exa, -l to install lsd
			EOF
      exit 0
      ;;
    -p|-P)
      port=$2
      shift
      ;;
    -i|-o)
      opts+=("$1" "$2")
      shift
      ;;
    -u|-g)
      remoteOpts+=("$1" "$2")
      shift
      ;;
    -e|-l)
      remoteOpts+=("$1")
      ;;
    -*)
      ;;
    *)
      hosts+=("$1")
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
    cat $DOT/init_remote.bash | ssh -p $port $opts $host "bash -s -x -- $remoteOpts"
  fi
done
popd
