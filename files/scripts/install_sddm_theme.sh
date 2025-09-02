#!/usr/bin/env bash
set -euo pipefail

SDDM_THEMES_DIR="/usr/share/sddm/themes"
TMP_DIR="$(mktemp -d)"

# ===============================
# User-configurable variables
# ===============================
FLAVOR="mocha"   # latte | frappe | macchiato | mocha
COLOR="lavender" # blue | flamingo | green | lavender | maroon | mauve | peach | pink | red | rosewater | sapphire | sky | teal | yellow

# Construct theme file name
THEME_NAME="catppuccin-${FLAVOR}-${COLOR}"
THEME_FILE="${THEME_NAME}-sddm.zip"

echo "[+] Installing Catppuccin SDDM theme: $FLAVOR / $COLOR"
sudo mkdir -p "$SDDM_THEMES_DIR"

# Fetch latest release JSON from SDDM repo
ASSETS_JSON="$(curl -s "https://api.github.com/repos/catppuccin/sddm/releases/latest")"

# Match the asset by name
ASSET_URL=$(echo "$ASSETS_JSON" | jq -r --arg NAME "$THEME_FILE" '.assets[] | select(.name == $NAME) | .browser_download_url')

if [ -z "$ASSET_URL" ] || [ "$ASSET_URL" == "null" ]; then
  echo "[!] Theme $THEME_FILE not found in latest release!"
  exit 1
fi

# Download
file="$TMP_DIR/$THEME_FILE"
echo "[+] Downloading $THEME_FILE"
curl -L -o "$file" "$ASSET_URL"

# Extract
echo "[+] Extracting theme..."
unzip -q "$file" -d "$TMP_DIR"

# Move theme folder to SDDM themes dir
TARGET_DIR="$SDDM_THEMES_DIR/$THEME_NAME"
sudo rm -rf "$TARGET_DIR"
sudo mv -v "$TMP_DIR/$THEME_NAME" "$SDDM_THEMES_DIR/"

# Cleanup
rm -rf "$TMP_DIR"

# Set FontSize
sudo sed -i 's/FontSize=.*/FontSize=12/' "$TARGET_DIR/theme.conf"

# Disable CustomBackground
sed -i 's/CustomBackground=.*/CustomBackground=false/' "$TARGET_DIR/theme.conf"

echo "[✓] Installed SDDM theme: $TARGET_DIR"
