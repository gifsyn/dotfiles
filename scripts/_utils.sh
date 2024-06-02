#!/bin/bash
set -u

# print info message in cyan
function print_info() {
    echo -e "\e[96m[INFO]\e[0m $1"
}

# print error message in red
function print_error() {
    echo -e "\e[91m[ERROR]\e[0m $1"
}

# print warning message in yellow
function print_warn() {
    echo -e "\e[93m[WARN]\e[0m $1"
}

# print prompt message in magenta
function print_prompt_yn() {
    read -p $'\e[95m[PROMPT]\e[0m '"$1" yn
}

# run command
function run_command() {
    local command="$1"
    echo -e "$ $command" | sed 's/^/    /'
    output=$(eval "$command" 2>&1)
    if [ $? -ne 0 ]; then
        print_error "$output"
        exit 1
    fi
}
