#!/data/data/com.termux/files/usr/bin/bash
case "$1" in
h | help | -h | --help)
  echo "Usage: $0 <module|all> <version|init|noinit>"
  exit 0
  ;;
esac
declare -a MODULES
MODULES+=("$@")
if ((${#MODULES[@]}==0)) || [[ "${MODULES[*]}" == "all" ]]; then
  MODULES=(bat exa delta fd fzf glow hexyl jq lsd node ripgrep rclone)
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
