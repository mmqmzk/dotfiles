#!/usr/bin/env bash

set -e

case "$1" in
h | help | -h | --help)
  echo "Usage: $0 <module|all> <version|init|noinit>"
  exit 0
  ;;
esac
declare -a MODULES
MODULES+=("$@")
if ((${#MODULES[@]}==0)) || [[ "${MODULES[*]}" == "all" ]]; then
  MODULES=(baidu delta fzf glow jq lsd v2sub node)
fi
pushd "$(dirname "$0")" &>/dev/null
source ./functions.bash
for mod in "${MODULES[@]}"; do
  if [[ "${mod}" == "node" ]]; then
    install_node --lts
  else
    "install_${mod}"
  fi
done
popd &>/dev/null
