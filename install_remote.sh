#!/usr/bin/env bash

set -e

DOT="${DOT:-"${HOME}/.dotfiles"}"
TMP="${DOT}/tmp"

declare -a hosts
declare -a opts
port=22
remoteOpts=
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
      port="$2"
      shift
      ;;
    -i|-o)
      opts+=("$1" "$2")
      shift
      ;;
    -u|-g)
      remoteOpts="${remoteOpts} '$1' '$2'"
      shift
      ;;
    -e|-l)
      remoteOpts="${remoteOpts} '$1'"
      ;;
    -*)
      ;;
    *)
      hosts+=("$1")
      ;;
  esac
  shift
done
pushd "${TMP}"
for host in "${hosts[@]}"; do
  if [[ -n "${host}" ]]; then
    rsync --ssh "ssh -p ${port} ${opts[*]}" dot.tbz2 "${host}":~
    ssh -p "${port}" "${opts[@]}"  "${host}" "bash -s -x -- ${remoteOpts}" < "${DOT}/init_remote.bash"
  fi
done
popd
