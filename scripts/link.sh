#!/bin/bash
set -u

# load utils.sh
source "$HOME/dotfiles/scripts/utils.sh"

dotfiles_project_dir="$HOME/dotfiles"
dotfiles_dir="dotfiles"

print_info "\e[96mLink started...\e[0m"

# link files to $HOME
for file in $(find "$dotfiles_project_dir/$dotfiles_dir" -mindepth 1 -maxdepth 1 -type f); do
    ln -svf "$file" "$HOME/$(basename $file)" | while read -r line; do print_info "$line"; done
done

# link directories to $HOME
for dir in $(find "$dotfiles_project_dir/$dotfiles_dir" -mindepth 1 -maxdepth 1 -type d); do
    if [ ! -e "$HOME/$(basename $dir)" ]; then
        ln -sv "$dir" "$HOME/$(basename $dir)" | while read -r line; do print_info "$line"; done
    fi
done

print_info "\e[96mLink completed!\e[0m"
