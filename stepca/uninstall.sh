#!/usr/bin/env bash

sudo update-alternatives --remove-all step && \
sudo dpkg -P step-cli
