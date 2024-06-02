#!/bin/bash
set -u

# load _utils.sh
source "$HOME/dotfiles/scripts/_utils.sh"


# ======== update & upgrade APT packages ========
function update_upgrade_apt_packages() {
    print_info "APT packages updating & upgrading started..."
    run_command "sudo apt-get update -y"
    run_command "sudo apt-get upgrade -y"
    print_info "APT packages updating & upgrading completed!"
    echo ""
}


# ======== install APT packages ========
function install_apt_packages() {
    print_info "APT packages installation started..."
    run_command "sudo apt install -y git"
    run_command "sudo apt install -y vim"
    run_command "sudo apt install -y curl"
    run_command "sudo apt install -y wget"
    print_info "APT packages installation completed!"
    echo ""
}


# ======== Chrome ========
function install_chrome() {
    print_info "Chrome installation started..."
    if command -v google-chrome &> /dev/null; then
        print_info "Chrome already installed!"
        return
    fi

    run_command 'wget -O /tmp/google-chrome-stable_current_amd64.deb -L "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"'
    run_command "sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb"
    print_info "Chrome installation completed!"
    echo ""
}


# ======== Edge ========
function install_edge() {
    print_info "Edge installation started..."
    if command -v microsoft-edge &> /dev/null; then
        print_info "Edge already installed!"
        return
    fi

    run_command 'wget -O /tmp/microsoft-edge-stable.deb "https://go.microsoft.com/fwlink?linkid=2149051"'
    run_command "sudo apt install -y /tmp/microsoft-edge-stable.deb"
    print_info "Edge installation completed!"
    echo ""
}

# ======== Brave ========
function install_brave() {
    print_info "Brave installation started..."
    if command -v brave-browser &> /dev/null; then
        print_info "Brave already installed!"
        return
    fi

    # ref: https://brave.com/linux/
    run_command "sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
    run_command 'echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list'
    run_command "sudo apt update"
    run_command "sudo apt install -y brave-browser"
    print_info "Brave installation completed!"
    echo ""
}


# ======== VSCode ========
function install_vscode() {
    print_info "VSCode installation started..."
    if command -v code &> /dev/null; then
        print_info "VSCode already installed!"
        return
    fi

    run_command 'wget -O /tmp/code.deb -L "https://go.microsoft.com/fwlink/?LinkID=760868"'
    run_command "sudo apt install -y /tmp/code.deb"
    print_info "VSCode installation completed!"
    echo ""
}


# ======== VSCode Insiders ========
function install_vscode_insiders() {
    print_info "VSCode Insiders installation started..."
    if command -v code-insiders &> /dev/null; then
        print_info "VSCode Insiders already installed!"
        return
    fi

    run_command 'wget -O /tmp/code-insiders.deb -L "https://update.code.visualstudio.com/latest/linux-deb-x64/insider"'
    run_command "sudo apt install -y /tmp/code-insiders.deb"
    print_info "VSCode Insiders installation completed!"
    echo ""
}


# ======== JetBrains Toolbox ========
function install_jetbrains_toolbox() {
    print_info "JetBrains Toolbox installation started..."
    if command -v jetbrains-toolbox &> /dev/null; then
        print_info "JetBrains Toolbox already installed!"
        return
    fi

    run_command "sudo apt install -y libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin tar dbus-user-session"
    run_command 'wget -O /tmp/jetbrains-toolbox.tar.gz -L "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"'
    run_command "tar -xzf /tmp/jetbrains-toolbox.tar.gz -C /tmp/"
    latest_jetbrains_toolbox=$(ls -1 /tmp/ | grep jetbrains-toolbox- | sort -r | head -n 1)
    run_command "/tmp/$latest_jetbrains_toolbox/jetbrains-toolbox"
    print_info "JetBrains Toolbox installation completed!"
    echo ""
}


# ======== Slack ========
function install_slack() {
    print_info "Slack installation started..."
    if command -v slack &> /dev/null; then
        print_info "Slack already installed!"
        return
    fi

    run_command 'wget -O /tmp/slack.deb -L "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.38.125/slack-desktop-4.38.125-amd64.deb"'
    run_command "sudo apt install -y /tmp/slack.deb"
    print_info "Slack installation completed!"
    echo ""
}


# ======== Discord ========
function install_discord() {
    print_info "Discord installation started..."
    if command -v discord &> /dev/null; then
        print_info "Discord already installed!"
        return
    fi

    run_command 'wget -O /tmp/slack.deb -L "https://discord.com/api/download?platform=linux&format=deb"'
    run_command "sudo apt install -y /tmp/discord.deb"
    print_info "Discord installation completed!"
    echo ""
}


# ======== Docker ========
function install_docker() {
    print_info "Docker installation started..."
    if command -v docker &> /dev/null; then
        print_info "Docker already installed!"
        return
    fi

    run_command "sudo apt-get update -y"
    run_command "sudo apt-get install -y ca-certificates curl"
    run_command "sudo install -m 0755 -d /etc/apt/keyrings"
    run_command "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
    run_command "sudo chmod a+r /etc/apt/keyrings/docker.asc"
    run_command 'echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
    run_command "sudo apt-get update -y"

    run_command "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    run_command "sudo groupadd docker"
    run_command "sudo usermod -aG docker $USER"
    run_command "newgrp docker"
    print_info "Docker installation completed!"
}
