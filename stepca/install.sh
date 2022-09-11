#!/usr/bin/env bash

is_installed() {
    (which $1 >/dev/null 2>&1) && return 0 || return 1
}

install_deb_step() {
    is_installed curl || sudo apt install -y curl
    VERSION=$(curl 'https://github.com/smallstep/cli/releases/latest' -si | grep -Po '(?<=tag\/v)\d+.\d+.\d+')
    INSTALLATION_DIR="/opt/step"
    FILENAME="step-cli_${VERSION}_amd64.deb"
    INSTALLATION_FILE="${INSTALLATION_DIR}/${FILENAME}"
    if !(sudo test -f $INSTALLATION_FILE); then
        sudo mkdir -p $INSTALLATION_DIR && \
        sudo wget -O $INSTALLATION_FILE \
            "https://dl.step.sm/gh-release/cli/docs-cli-install/v${VERSION}/${FILENAME}" || \
        exit 1;
    fi
    sudo dpkg -i $INSTALLATION_FILE
}

install_win_step() {
    scoop bucket add smallstep https://github.com/smallstep/scoop-bucket.git
    scoop install smallstep/step
}

if !(is_installed step); then
    (is_installed dpkg && install_deb_step ) || \
    (is_installed apk && apk add step-cli ) || \
    (is_installed brew && brew install step ) || \
    (is_installed pacman && pacman -S step-cli ) || \
    (is_installed nix-shell && nix-shell -p step-cli ) || \
    (is_installed pkg && pkg install step-cli ) || \
    (is_installed scoop && install_win_step ) || \
    (echo "Unable to install step-cli" && exit 1)
else
    echo "Already installed step-cli"
fi
