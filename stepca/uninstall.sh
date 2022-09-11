#!/usr/bin/env bash

is_installed() {
    (which $1 >/dev/null 2>&1) && return 0 || return 1
}

is_installed dpkg && \
is_installed update-alternatives && \
sudo update-alternatives --remove-all step && \
sudo dpkg -P step-cli ||:
