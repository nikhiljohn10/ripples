#!/usr/bin/env bash

VERSION="0.22.0"
DOWNLOAD_DIR="/opt/step"
FILE="step-cli_${VERSION}_amd64.deb"
DOWNLOAD_FILE="$DOWNLOAD_DIR/$FILE"

if !(sudo test -f "$DOWNLOAD_FILE"); then
    sudo mkdir -p $DOWNLOAD_DIR && \
    sudo wget -O $DOWNLOAD_FILE "https://dl.step.sm/gh-release/cli/docs-cli-install/v${VERSION}/${FILE}" || \
    exit 1
fi
sudo dpkg -i $DOWNLOAD_FILE ||:
