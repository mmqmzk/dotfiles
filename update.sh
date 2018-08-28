#!/usr/bin/env bash
if [[ -z $2 ]]; then
    echo "Usage: $0 <module> <version|init dot> [curl proxy]"
    exit 1
fi
cd $(dirname $0)
mod=$1
version=$2
shift 2
proxy=$@
source ./functions.sh
install_$mod $version
