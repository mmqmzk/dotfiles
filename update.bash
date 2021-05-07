#!/usr/bin/env bash
case "$1" in
h | help | -h | --help)
  echo "Usage: $0 <module|all> <version|init|noinit>"
  exit 0
  ;;
esac
declare -a MODULES
MODULES+=("$@")
if ((${#MODULES[@]}==0)) || [[ "${MODULES[*]}" == "all" ]]; then
  MODULES=(baidu bat exa delta fd fzf glow hexyl jq lsd node ripgrep rclone v2sub)
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
