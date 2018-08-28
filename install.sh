#!/usr/bin/env bash
proxy=$@
dir=$(dirname $0)
init=/tmp/init.sh
curl $proxy -fsSL https://github.com/mmqmzk/dotfiles/raw/master/functions.sh > /tmp/functions.sh
curl $proxy -fsSL https://github.com/mmqmzk/dotfiles/raw/master/init.sh > $init
chmod 755 $init
$init $proxy
