#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# SETUP: Define installation path
INSTALL_DIR="$HOME/.local/share/tuxbox"

# IO: Install dependencies
log_info "Installing dependencies..."
sudo pacman -S --needed --noconfirm python-pip

# IO: Fetch and install Tuxbox
if [ ! -d "$INSTALL_DIR" ]; then
	log_info "Installing Tuxbox..."
	git clone https://github.com/AndyCappDev/tuxbox.git "$INSTALL_DIR"

	# NOTE: Bypass the autostart prompt by providing 'n' as input
	printf "n\n" | bash "$INSTALL_DIR/install.sh"
else
	log_warn "Tuxbox is already installed at $INSTALL_DIR"
fi

# LOG: Print successful completion
log_success "Tuxbox installed successfully at $INSTALL_DIR"
