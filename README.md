# dotsu (ドツ)

A minimal dotfiles configuration for Arch Linux based on Hyprland.

## Architecture

This project uses a `root` + `user` architecture:
- `root`: Default configurations for the system.
- `user`: Personal overrides and custom scripts.

## Stack

| Category | Component |
| :--- | :--- |
| **Compositor** | [Hyprland](https://hypr.land) |
| **Terminal** | [Foot](https://codeberg.org/dnkl/foot) |
| **Ecosystem** | `hypr*` (paper, lock, idle, picker, sunset, polkitagent, shutdown, pwcenter) |
| **File Manager** | [Yazi](https://github.com/sxyazi/yazi) |
| **Tools** | `xdg-desktop-portal-hyprland`, `wl-clipboard`, `grim`, `slurp`, `xorg-xrdb` |
| **Font** | [JetBrains Mono Nerd Font](https://www.nerdfonts.com) |

## Installation

### Phase 1: Base System

1. Boot the latest Arch Linux ISO and run `archinstall`.
2. Use these specific settings for maximum compatibility:
	- **Disk configuration:** Create a `fat32` partition for `/boot` and an `ext4` or `btrfs` partition for `/`.
	- **Bootloader:** `systemd-boot`.
	- **Authentication:** Create a user and give it sudo privileges.
	- **Profile:** `minimal`.
	- **Applications:** Enable Bluetooth and select `pipewire` for Audio.
	- **Network configuration:** Select `Copy ISO network configuration to installation`.
	- **Additional packages:** `git`, `iwd`, and your specific GPU drivers (e.g., `nvidia-open-dkms`).
	- **Timezone:** Set your local timezone.
3. Complete the installation and reboot.

### Phase 2: Core Infrastructure

1. Login to the TTY and clone this repository (or your fork):
	```bash
	git clone https://github.com/rukipsi/dotsu.git ~/dotsu
	```
2. Run the root installer:
	```bash
	cd ~/dotsu/root/scripts
	./install.sh
	```
3. Reboot the system:
	```bash
	sudo reboot
	```

### Phase 3: Customization

If you have a fork, ensure your changes are pushed; otherwise, edit the local files directly.

1. Customize your environment by editing the files in `user/`:
	- `user/.config/foot/foot.ini`: Terminal styling.
	- `user/.config/hypr/hyprland.lua`: Keybinds, monitors, and autostart.
	- `user/.config/hypr/hyprpaper.conf`: Wallpaper settings.
	- `user/packages/pkglist.txt`: Arch packages you might want to install.
	- `user/packages/aur-pkglist.txt`: AUR packages you might want to install.
2. Apply the customization:
	```bash
	cd ~/dotsu/user/scripts
	./install.sh
	```
3. Run optional component scripts as needed:
	- `./apps/clip-studio-paint.sh`: Install Clip Studio Paint (Wine).
	- `./apps/tuxbox.sh`: Install TuxBox (for TourBox Controller).
	- `./setup/git.sh`: Apply conventional commits hook for git commit messages.
	- `./setup/keyring.sh`: Configure GNOME Keyring.
	- `./setup/wireplumber.sh`: Apply Bluetooth autoswitch fixes.

## Specifications

This project follows strict standards to ensure maintainability and clarity:

- **[Semantic Versioning](https://semver.org/spec/v2.0.0.html):** A simple set of rules and requirements that dictate how version numbers are assigned and incremented.
- **[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0):** A specification for adding human and machine readable meaning to commit messages.
- **[Keep a Changelog](https://keepachangelog.com/en/1.1.0):** A file containing a curated and chronological list of notable project changes.
- **[komento (コメント)](https://github.com/rukipsi/komento):** A minimal standard for internal code comments.

## Contributing

1. Create a new branch `feature/[name]` or `bug/[name]`.
2. Follow the [specifications](#specifications) for all changes.
3. Create a pull request.
4. Become a legend.

## License

This project is licensed under the [MIT](LICENSE) license.

## Legends (Contributors)

- [@rukipsi](https://github.com/rukipsi)
