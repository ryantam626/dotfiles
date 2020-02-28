#!/bin/bash

set -e

SCRIPT_PATH=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename "$0")")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)/

source $SCRIPT_DIR/helpers.sh
source $SCRIPT_DIR/installers.sh

install_zsh_plugins

success "All done."
