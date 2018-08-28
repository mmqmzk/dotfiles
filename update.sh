#!/usr/bin/env bash
if [[ -z $2 ]]; then
    echo "Usage: $0 <module> <version|init dot>"
    exit 1
fi
cd $(dirname $0)
source ./functions.sh
install_$1 $2
