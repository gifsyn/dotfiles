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
