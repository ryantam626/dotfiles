#!/bin/bash

set -e

SCRIPT_PATH=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename "$0")")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)/

source $SCRIPT_DIR/helpers.sh
source $SCRIPT_DIR/installers.sh

install_python3
install_wm
install_launcher
install_terminal
install_utils
install_theme
install_sublime
install_pywal
install_fonts
install_docker
install_nix
install_pycharm
install_spotify
install_telegram

# placed last because this ends with a chsh and effectively halts the script
install_zsh

success "All done."
