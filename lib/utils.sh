#!/usr/bin/env bash

# SETUP: Initialize environment paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# LOG: Define logging utilities
log_info() { echo -e "\e[34m[INFO]\e[0m $*"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $*"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $*" >&2; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $*" >&2; }

# UI: Define interactive prompt utilities
prompt_input() {
    local -n var_ref="$1"
    local prompt_text="$2"
    echo -ne "\e[36m[INPUT]\e[0m $prompt_text: "
    read -r var_ref
}

prompt_secure() {
    local -n var_ref="$1"
    local prompt_text="$2"
    echo -ne "\e[36m[INPUT]\e[0m $prompt_text (hidden): "
    read -rs var_ref
    echo ""
}
