#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# LOG: Print script start
log_info "Overriding wireplumber settings (bluetooth)"

# IO: Create target directory
mkdir -p "$HOME/.config/wireplumber/wireplumber.conf.d"

# IO: Link personal wireplumber overrides
ln -sf "$DOTFILES_DIR/user/.config/wireplumber/wireplumber.conf.d/10-disable-headset-autoswitch.conf" "$HOME/.config/wireplumber/wireplumber.conf.d/10-disable-headset-autoswitch.conf"

# LOG: Print successful completion
log_success "Wireplumber overrides applied successfully"
