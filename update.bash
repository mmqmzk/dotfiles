#!/usr/bin/env bash
if [[ -z $1 ]]; then
    echo "Usage: $0 <module> <version|init|noinit>"
    exit 1
fi
cd $(dirname $0)
MOD=$1
VERSION=$2
source ./functions.bash
"install_$MOD" "$VERSION"
