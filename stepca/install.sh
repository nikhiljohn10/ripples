#!/usr/bin/env bash

is_installed() {
    (which $1 >/dev/null 2>&1) && return 0 || return 1
}

install_win_step() {
    scoop bucket add smallstep https://github.com/smallstep/scoop-bucket.git
    scoop install smallstep/step
}

install_linux() {
    test "$(uname)" != "Linux" && return 1
    curl -L -o step https://dl.step.sm/s3/cli/ui-cli-install/step_latest_linux_amd64
    sudo install -m 0755 -t /usr/bin step
}

if !(is_installed step); then
    install_linux || \
    (is_installed brew && brew install step ) || \
    (is_installed scoop && install_win_step ) || \
    (echo "Unable to install step-cli" && exit 1)
else
    echo "Already installed step-cli"
fi
