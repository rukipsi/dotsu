#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# LOG: Print script start
log_info "Starting Git and SSH configuration..."

# UI: Interactive prompts for name and email 
prompt_input GIT_NAME "Enter your Git username"
prompt_input GIT_EMAIL "Enter your Git email address"

# IO: Set up global Git profile
log_info "Configuring global Git profile..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# IO: Set up static configurations and hooks
git config --global core.hooksPath "$HOME/.config/git/hooks"
git config --global core.editor nano
git config --global gpg.format ssh
git config --global commit.gpgsign true

# IO: Create git hooks directory and link the commit-msg hook
mkdir -p "$HOME/.config/git/hooks"
ln -sf "$DOTFILES_DIR/user/.config/git/hooks/commit-msg" "$HOME/.config/git/hooks/commit-msg"
log_success "Git hooks linked successfully"

# LOGIC: Check/Generate SSH Key
KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$KEY_PATH" ]; then
    log_info "No SSH key found. Generating a new Ed25519 key..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY_PATH"
else
    log_info "Existing SSH key found at $KEY_PATH. Skipping generation."
fi

# IO: Link public key to Git for commit signing
git config --global user.signingkey "$KEY_PATH.pub"
log_success "SSH signing key linked to Git"

# LOG: Print successful completion and setup instructions
log_success "Git and SSH setup complete!"
log_info "IMPORTANT NEXT STEP:"
log_info "To authorize and verify commits, you must add this key to your GitHub account."
log_info "1. Go to: GitHub Settings -> SSH and GPG keys -> New SSH key"
log_info "2. Add it ONCE as an 'Authentication Key'"
log_info "3. Add it AGAIN as a 'Signing Key'"
log_info "Copy your public key below:"
cat "$KEY_PATH.pub"
