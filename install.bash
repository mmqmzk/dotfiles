#!/usr/bin/env bash
INIT=/tmp/init.bash
curl -fsSL https://github.com/mmqmzk/dotfiles/raw/master/functions.bash >/tmp/functions.bash
curl -fsSL https://github.com/mmqmzk/dotfiles/raw/master/init.bash >"${INIT}"
chmod 755 "${INIT}"
${INIT}
