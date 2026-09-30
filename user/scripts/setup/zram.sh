#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# LOG: Print script start
log_info "Configuring zram compressed swap..."

# SETUP: Define configuration path
CONF_FILE="/etc/systemd/zram-generator.conf"

# IO: Write zram generator configuration
log_info "Writing configuration to $CONF_FILE..."
sudo tee "$CONF_FILE" >/dev/null <<'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF

# IO: Reload systemd and start the zram device
log_info "Initializing zram service..."
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service

# LOG: Print successful completion
log_success "zram configured and activated successfully"
