export PATH="$HOME/.local/bin:$PATH"

if [ "$(tty)" = "/dev/tty1" ]; then
	exec start-hyprland
fi
