#!/bin/bash
set -u

# load utils.sh
source "$HOME/dotfiles/scripts/utils.sh"

dotfiles_project_dir="$HOME/dotfiles"
backup_dir="backup"
backup_list=(
    "$HOME/.bashrc"
    "$HOME/.profile"
    "$HOME/.bash_profile"
    "$HOME/.bash_logout"
)

print_info "\e[96mBackup started...\e[0m"

# check if backup directory is empty (exclude .gitkeep)
if [ "$(ls -A $dotfiles_project_dir/$backup_dir | grep -v .gitkeep)" ]; then
    print_warn "Backup directory($dotfiles_project_dir/$backup_dir) is not empty"
    while true; do
        print_prompt_yn "Do you want to continue and overwrite existing files? (y/n) "
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) echo ""; exit 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
fi

# copy files to backup directory
for backup_item in "${backup_list[@]}"; do
    if [ -f "$backup_item" ]; then
        # cp　コマンドの-vオプションの出力をprint_info関数で表示
        cp -v "$backup_item" "$dotfiles_project_dir/$backup_dir" | while read -r line; do print_info "$line"; done
    elif [ -d "$backup_item" ]; then
        cp -rv "$backup_item" "$dotfiles_project_dir/$backup_dir" | while read -r line; do print_info "$line"; done
    else
        print_warn "'$backup_item' -> not found and skipped"
    fi
done

print_info "\e[96mBackup completed!\e[0m"
