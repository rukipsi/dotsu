#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# LOG: Print script start
log_info "Setting up Git hooks..."

# IO: Create target directory
mkdir -p "$HOME/.config/git/hooks"

# IO: Create global git hooks configuration
git config --global core.hooksPath "$HOME/.config/git/hooks"

# IO: Link the commit-msg hook
ln -sf "$DOTFILES_DIR/user/.config/git/hooks/commit-msg" "$HOME/.config/git/hooks/commit-msg"

# LOG: Print successful completion
log_success "Git hooks configured successfully"
