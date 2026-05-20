#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# IO: Install official packages from dotfiles lists
log_info "Installing official user packages..."
sudo pacman -S --needed --noconfirm - <"$DOTFILES_DIR/user/packages/pkglist.txt"

# IO: Install AUR packages from dotfiles lists
log_info "Installing AUR user packages..."
paru -S --needed --noconfirm - <"$DOTFILES_DIR/user/packages/aur-pkglist.txt"

# IO: Download user assets from GitHub releases
if [ ! -f "$DOTFILES_DIR/user/.config/wallpapers/wallpaper.jpg" ]; then
	log_info "Downloading user assets..."
	curl -sSL "https://github.com/rukipsi/dotsu/releases/download/v1.0.0/user.tar.gz" | tar -xzC "$DOTFILES_DIR/user"
fi

# IO: Create target directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/foot/user"
mkdir -p "$HOME/.config/hypr/user"
mkdir -p "$HOME/.config/wallpapers"

# IO: Link personal binaries
ln -sf "$DOTFILES_DIR/user/.local/bin/"* "$HOME/.local/bin/"

# IO: Link user configuration overrides
ln -sf "$DOTFILES_DIR/user/.config/foot/foot.ini" "$HOME/.config/foot/user/foot.ini"
ln -sf "$DOTFILES_DIR/user/.config/hypr/hyprland.lua" "$HOME/.config/hypr/user/hyprland.lua"
ln -sf "$DOTFILES_DIR/user/.config/hypr/hyprpaper.conf" "$HOME/.config/hypr/user/hyprpaper.conf"

# IO: Link personal wallpaper
ln -sf "$DOTFILES_DIR/user/.config/wallpapers/wallpaper.jpg" "$HOME/.config/wallpapers/wallpaper.jpg"

# LOG: Print successful completion
log_success "User environment setup complete"
