#!/usr/bin/env bash

is_installed() {
    (which $1 >/dev/null 2>&1) && return 0 || return 1
}

remove_step() {
    test -f "/usr/bin/step" || return 1
    sudo rm -f /usr/bin/step
}

if is_installed step; then
    install_linux || \
    (is_installed brew && brew remove -f step ) || \
    (is_installed scoop && scoop uninstall step) || \
    (echo "Unable to install step-cli" && exit 1)
else
    echo "Already uninstalled step-cli"
fi
