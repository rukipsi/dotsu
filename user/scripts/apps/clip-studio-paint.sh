#!/usr/bin/env bash
set -euo pipefail

# SETUP: Import utilities
source "$(dirname "${BASH_SOURCE[0]}")/../../../lib/utils.sh"

# SETUP: Define Wine environment
export WINEPREFIX="$HOME/.wine-csp"
export WINEARCH=win64

# SETUP: Define installer URLs
CSP_URL="https://vd.clipstudio.net/clipcontent/paint/app/308/CSP_308w_setup.exe"
WEBVIEW_URL="https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/76eb3dc4-7851-45b7-a392-460523b0e2bb/MicrosoftEdgeWebView2RuntimeInstallerX64.exe"

# IO: Install dependencies
log_info "Installing Wine dependencies..."
sudo pacman -S --needed --noconfirm cabextract gst-plugins-good gst-plugins-bad wine wine-gecko wine-mono winetricks

# SETUP: Initialize Wine prefix
log_info "Initializing Wine prefix at $WINEPREFIX..."
wineboot --init

# SETUP: Apply 4K scaling (144 DPI)
log_info "Applying Wine registry fixes..."
wine reg add "HKCU\Software\Wine" /v Version /t REG_SZ /d "win10" /f
wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 144 /f

# SETUP: Configure DLL overrides to fix UI glitches
log_info "Configuring launcher fixes..."
echo "dxgi.deferSurfaceCreation = True" >"$WINEPREFIX/dxvk.conf"
wine reg add "HKCU\Software\Wine\AppDefaults\CLIPStudio.exe\DllOverrides" /v "dcomp" /t REG_SZ /d "native" /f
wine reg add "HKCU\Software\Wine\AppDefaults\CLIPStudio.exe\DllOverrides" /v "libwinpthread-1" /t REG_SZ /d "native" /f
wine reg add "HKCU\Software\Wine\DllOverrides" /v "dcomp" /t REG_SZ /d "native,builtin" /f
wine reg add "HKCU\Software\Wine\DllOverrides" /v "concrt140" /t REG_SZ /d "native,builtin" /f
wine reg add "HKCU\Software\Wine\AppDefaults\CLIPStudio.exe" /v "WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS" /t REG_SZ /d "--disable-gpu --no-sandbox" /f

# IO: Install Windows components via winetricks
log_info "Installing Windows components (this may take a while)..."
winetricks -q corefonts cjkfonts vcrun2022 dotnet48 dxvk vkd3d

# IO: Download and inject missing custom patches required for Wine compatibility
if [ ! -d "$DOTFILES_DIR/user/patches/csp" ]; then
	log_info "Downloading patches from GitHub..."
	curl -sSL "https://github.com/rukipsi/dotsu/releases/download/v1.0.0/user.tar.gz" | tar -xzC "$DOTFILES_DIR/user"
fi
cp "$DOTFILES_DIR/user/patches/csp/dcomp.dll" "$WINEPREFIX/drive_c/windows/system32/dcomp.dll"
cp "$DOTFILES_DIR/user/patches/csp/libwinpthread-1.dll" "$WINEPREFIX/drive_c/windows/system32/libwinpthread-1.dll"

# IO: Execute application installers
log_info "Installing Microsoft Edge WebView2..."
curl -L "$WEBVIEW_URL" -o /tmp/webview2_setup.exe
wine /tmp/webview2_setup.exe
log_info "Installing Clip Studio Paint v3..."
curl -L "$CSP_URL" -o /tmp/csp_setup.exe
WINEDLLOVERRIDES="winemenubuilder.exe=d" wine /tmp/csp_setup.exe

# WRAP: Remove temporary installers
rm -f /tmp/webview2_setup.exe /tmp/csp_setup.exe

# SETUP: Apply runtime compatibility fixes
log_info "Applying post-install version fixes..."
wine reg add "HKCU\Software\Wine\AppDefaults\msedgewebview2.exe" /v Version /t REG_SZ /d "win7" /f
wine reg add "HKCU\Software\Wine\AppDefaults\CLIPStudio.exe" /v Version /t REG_SZ /d "win81" /f
wine reg add "HKCU\Software\Wine\AppDefaults\CLIPStudioPaint.exe" /v Version /t REG_SZ /d "win81" /f

# WRAP: Terminate Wine background processes
wineserver -k

# UI: Display completion status and launch instructions
log_success "Clip Studio Paint installed successfully"
log_info 'Launch the application using: WINEPREFIX="$HOME/.wine-csp" wine explorer /desktop=CS,3840x2160 "$HOME/.wine-csp/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5/CLIP STUDIO/CLIPStudio.exe"'
