#!/usr/bin/env bash
proxy=$@
dir=$(dirname $0)
curl $proxy -fsSL https://github.com/mmqmzk/dotfiles/raw/master/functions.sh > /tmp/functions.sh
curl $proxy -fsSL https://github.com/mmqmzk/dotfiles/raw/master/install.sh > /tmp/install.sh
chmod 755 /tmp/install.sh
/tmp/install.sh $proxy
