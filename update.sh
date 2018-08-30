#!/usr/bin/env bash
if [[ -z $2 ]]; then
    echo "Usage: $0 <module> <version|init> [curl proxy]"
    exit 1
fi
cd $(dirname $0)
MOD=$1
VERSION=$2
shift 2
export PROXY=$@
source ./functions.sh
install_$MOD $VERSION
