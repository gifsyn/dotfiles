#!/bin/bash
set -u

# load utils.sh
source "$HOME/dotfiles/scripts/utils.sh"

# ======== update .bashrc ========
print_info "\e[96mUpdate .bashrc started...\e[0m"
echo "" >> $HOME/.bashrc
echo '# source ~/.bashrc.d/*.bash' >> $HOME/.bashrc
echo 'for bash_file in $HOME/.bashrc.d/*.bash; do' >> $HOME/.bashrc
echo '    source "${bash_file}"' >> $HOME/.bashrc
echo 'done' >> $HOME/.bashrc
print_info "\e[96mUpdate .bashrc completed!\e[0m"
echo ""

# ======== update .profile ========
print_info "\e[96mUpdate .profile started...\e[0m"
echo "" >> $HOME/.profile
echo '# source ~/.profile.d/*.sh' >> $HOME/.profile
echo 'for sh_file in $HOME/.profile.d/*.sh; do' >> $HOME/.profile
echo '    source "${sh_file}"' >> $HOME/.profile
echo 'done' >> $HOME/.profile
print_info "\e[96mUpdate .profile completed!\e[0m"
