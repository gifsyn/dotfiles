#!/bin/bash
set -u

# get dotfiles directory path
DIR_DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# load scrips
source "$DIR_DOTFILES/scripts/_utils.sh"
source "$DIR_DOTFILES/scripts/_install.sh"

# check if config file is provided
if [ $# -eq 0 ]; then
    print_error "Please provide a config file!"
    exit 1
fi

# load config from $1(.config)
if [ -f "$1" ]; then
    source "$1"
else
    print_error "$1 not found!"
    exit 1
fi

# check if not root
if [ "$USER" == "root" ]; then
    print_error "Please run this script as a non-root user!"
    exit 1
fi

# ======== update & upgrade APT packages ========
update_upgrade_apt_packages

# ======== install APT packages ========
install_apt_packages

# ======== install input method ========
install_input_method

# ======== install Chrome ========
if "${INSTALL_CHROME}"; then
    install_chrome
fi

# ======== install Edge ========
if "${INSTALL_EDGE}"; then
    install_edge
fi

# ======== install Brave ========
if "${INSTALL_BRAVE}"; then
    install_brave
fi

# ======== install VSCode ========
if "${INSTALL_VSCODE}"; then
    install_vscode
fi

# ======== install VSCode Insiders ========
if "${INSTALL_VSCODE_INSIDERS}"; then
    install_vscode_insiders
fi

# ======== install Jetbrains Toolbox ========
if "${INSTALL_JETBRAINS_TOOLBOX}"; then
    install_jetbrains_toolbox
fi

# ======== install Slack ========
if "${INSTALL_SLACK}"; then
    install_slack
fi

# ======== install Discord ========
if "${INSTALL_DISCORD}"; then
    install_discord
fi

# ======== install Docker ========
if "${INSTALL_DOCKER}"; then
    install_docker
fi
