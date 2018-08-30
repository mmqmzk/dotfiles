#!/usr/bin/env bash
PROXY=$@
INIT=/tmp/init.sh
curl $PROXY -fsSL https://github.com/mmqmzk/dotfiles/raw/master/functions.sh > /tmp/functions.sh
curl $PROXY -fsSL https://github.com/mmqmzk/dotfiles/raw/master/init.sh > $INIT
chmod 755 $INIT
$INIT $PROXY
