#!/bin/bash
set -u

# check if dotfiles directory in $HOME
if [ ! -d "$HOME/dotfiles" ]; then
    # echo "dotfiles directory not found in $HOME"
    print_error "$HOME/dotfiles directory not found"
    exit 1
fi

# backup current directory
current_dir=$(pwd)
dotfiles_project_dir="$HOME/dotfiles"
scripts_dir="scripts"

# load utils.sh
source "$dotfiles_project_dir/$scripts_dir/utils.sh"

bash "$dotfiles_project_dir/$scripts_dir/backup.sh"
if [ $? -ne 0 ]; then
    exit 1
fi
echo ""

bash "$dotfiles_project_dir/$scripts_dir/link.sh"
if [ $? -ne 0 ]; then
    exit 1
fi
echo ""

bash "$dotfiles_project_dir/$scripts_dir/update_dotfiles.sh"
if [ $? -ne 0 ]; then
    exit 1
fi
echo ""

# ======== update & upgrade APT packages ========
print_info "\e[96mAPT packages updating & upgrading started...\e[0m"
print_info "\e[96msudo apt update -y\e[0m"
sudo apt update -y
print_info "\e[96msudo apt upgrade -y\e[0m"
sudo apt upgrade -y
print_info "\e[96mAPT packages updating & upgrading completed!\e[0m"
echo ""

# -------- install APT packages --------
print_info "\e[96mAPT packages installation started...\e[0m"
sudo apt install -y \
    git \
    vim \
    curl \
    wget \
    gcc \
    g++ \
    cmake
print_info "\e[96mAPT packages installation completed!\e[0m"
echo ""

# ======== pyenv ========
# ref:https://github.com/pyenv/pyenv
# ref:https://github.com/pyenv/pyenv/wiki
print_info "\e[96mpyenv installation started...\e[0m"
sudo apt update -y
sudo apt install -y \
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
export PYENV_DIR="$HOME/.pyenv" && (
    git clone https://github.com/pyenv/pyenv.git "$PYENV_DIR"
    cd "$PYENV_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
)
cd $HOME/.pyenv && src/configure && make -C src
print_info "\e[96mpyenv installation completed!\e[0m"
echo ""

# ======== nvm ========
# ref:https://github.com/nvm-sh/nvm
print_info "\e[96mnvm installation started...\e[0m"
export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
print_info "\e[96mnvm installation completed!\e[0m"
echo ""

print_info "\e[96mNode.js installation started...\e[0m"
nvm install --lts=hydrogen --latest-npm
nvm install --lts=iron --latest-npm
nvm alias default lts/hydrogen
print_info "\e[96mNode.js installation completed!\e[0m"
echo ""

# ======== Docker ========
# ref: https://docs.docker.com/engine/install/ubuntu/
print_info "\e[96mDocker installation started...\e[0m"

# -------- Uninstall old versions --------
# print_info "\e[96mUninstall old versions\e[0m"
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# -------- Uninstall Docker Engine --------
# print_info "\e[96mUninstall Docker Engine\e[0m"
# sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd

# -------- Install using the apt repository --------
print_info "\e[96mInstall using the apt repository\e[0m"

sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

print_info "\e[96mDocker installation completed!\e[0m"
echo ""

# ref: https://docs.docker.com/engine/install/linux-postinstall/
print_info "\e[96mDocker post-installation steps started...\e[0m"

# -------- Manage Docker as a non-root user --------
sudo groupadd docker || true
sudo usermod -aG docker $USER
# newgrp docker
newgrp docker << NEWGRP
NEWGRP

print_info "\e[96mDocker post-installation steps completed!\e[0m"

cd $current_dir
exec $SHELL -l
