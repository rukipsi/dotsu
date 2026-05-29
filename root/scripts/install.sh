#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# LOGIC: Prevent execution as the root user
if [[ $EUID -eq 0 ]]; then
	log_error "Run the script as a regular user with sudo privileges"
	exit 1
fi

# IO: Verify active internet connection
if ! ping -c 1 archlinux.org &>/dev/null; then
	log_error "No internet connection detected"
	exit 1
fi

# IO: Update core packages
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed base-devel --noconfirm

# IO: Bootstrap the 'paru' AUR helper if it is missing
if ! command -v paru &>/dev/null; then
	log_info "Installing paru (AUR helper)..."
	git clone https://aur.archlinux.org/paru.git /tmp/paru
	(cd /tmp/paru && makepkg -si --noconfirm)
fi

# IO: Install official packages from root lists
log_info "Installing official root packages..."
sudo pacman -S --needed --noconfirm - <"$DOTFILES_DIR/root/packages/pkglist.txt"

# IO: Install AUR packages from root lists
log_info "Installing AUR root packages..."
paru -S --needed --noconfirm - <"$DOTFILES_DIR/root/packages/aur-pkglist.txt"

# IO: Generate user configuration templates from examples
log_info "Checking for user configuration templates..."
[[ ! -f "$DOTFILES_DIR/user/.config/foot/foot.ini" ]] && cp "$DOTFILES_DIR/user/.config/foot/foot.ini.example" "$DOTFILES_DIR/user/.config/foot/foot.ini"
[[ ! -f "$DOTFILES_DIR/user/.config/hypr/hyprland.lua" ]] && cp "$DOTFILES_DIR/user/.config/hypr/hyprland.lua.example" "$DOTFILES_DIR/user/.config/hypr/hyprland.lua"
[[ ! -f "$DOTFILES_DIR/user/.config/hypr/hyprpaper.conf" ]] && cp "$DOTFILES_DIR/user/.config/hypr/hyprpaper.conf.example" "$DOTFILES_DIR/user/.config/hypr/hyprpaper.conf"

# IO: Download root assets from GitHub releases
if [ ! -d "$DOTFILES_DIR/root/.local/share/icons/Bibata-Modern-Ice-Hypr" ]; then
	log_info "Downloading root assets..."
	curl -sSL "https://github.com/rukipsi/dotsu/releases/download/v1.0.0/root.tar.gz" | tar -xzC "$DOTFILES_DIR/root"
fi

# LOG: Print the start of the symlink phase
log_info "Creating root symlinks..."

# IO: Prepare target directories
mkdir -p "$HOME/.config/foot/user"
mkdir -p "$HOME/.config/hypr/user"
mkdir -p "$HOME/.local/share/icons"

# IO: Create empty placeholders to prevent import errors
touch "$HOME/.config/foot/user/foot.ini"
touch "$HOME/.config/hypr/user/hyprland.lua"
touch "$HOME/.config/hypr/user/hyprpaper.conf"

# IO: Link core configuration files
ln -sf "$DOTFILES_DIR/root/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES_DIR/root/.config/foot/foot.ini" "$HOME/.config/foot/foot.ini"
ln -sf "$DOTFILES_DIR/root/.config/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
ln -sf "$DOTFILES_DIR/root/.config/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"

# IO: Link root assets
ln -sfn "$DOTFILES_DIR/root/.local/share/icons/Bibata-Modern-Ice" "$HOME/.local/share/icons/Bibata-Modern-Ice"
ln -sfn "$DOTFILES_DIR/root/.local/share/icons/Bibata-Modern-Ice-Hypr" "$HOME/.local/share/icons/Bibata-Modern-Ice-Hypr"

# IO: Enable network services
log_info "Enabling network services..."
sudo systemctl enable --now iwd

# UI: Display successful completion and next steps
log_success "Root environment setup complete"
log_info "Please reboot your system to apply all changes"
