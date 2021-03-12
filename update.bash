#!/data/data/com.termux/files/usr/bin/bash
MOD="${1:-"all"}"
case "${MOD}" in
h | help | -h | --help)
  echo "Usage: $0 <module|all> <version|init|noinit>"
  exit 1
  ;;
esac
VERSION="$2"
declare -a MODULES
MODULES=(bat exa fd fzf lsd q ripgrep xsv)
pushd "$(dirname "$0")" &>/dev/null
source ./functions.bash
if [[ "${MOD,,}" == "all" ]]; then
  for mod in "${MODULES[@]}"; do
    "install_${mod}" "${VERSION}"
  done
  install_node --lts
else
  "install_${MOD}" "${VERSION}"
fi
popd &>/dev/null
