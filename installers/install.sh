#!/bin/bash

set -e

SCRIPT_PATH=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename "$0")")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)/

source $SCRIPT_DIR/helpers.sh
source $SCRIPT_DIR/installers.sh

install_pyenv
install_wm
install_launcher
install_terminal
install_utils
install_theme
install_sublime
install_pywal
install_fonts
install_telegram
install_spotify
install_pycharm
install_docker

# placed last because this ends with a chsh and effectively halts the script
install_zsh

success "All done."
