#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# IO: Install dependencies
log_info "Installing dependencies..."
sudo pacman -S --needed --noconfirm gnome-keyring

# SETUP: Define the file
PAM_FILE="/etc/pam.d/login"

# IO: Create PAM auth entry
if ! grep -q "pam_gnome_keyring.so" "$PAM_FILE"; then
	sudo sed -i '/auth.*system-local-login/a auth       optional     pam_gnome_keyring.so' "$PAM_FILE"
	log_info "Created PAM auth entry"
fi

# IO: Create PAM session entry
if ! grep -q "pam_gnome_keyring.so auto_start" "$PAM_FILE"; then
	sudo sed -i '/session.*system-local-login/a session    optional     pam_gnome_keyring.so auto_start' "$PAM_FILE"
	log_info "Created PAM session entry"
fi

# LOG: Print successful completion
log_success "GNOME Keyring configured successfully"
