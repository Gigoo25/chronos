#!/usr/bin/env bash
set -euo pipefail

ICONS_DIR="/usr/share/icons"
TMP_DIR="$(mktemp -d)"

# ===============================
# User-configurable variables
# ===============================
FLAVOR="mocha"   # latte | frappe | macchiato | mocha
COLOR="lavender" # blue | flamingo | green | lavender | maroon | mauve | peach | pink | red | rosewater | sapphire | sky | teal | yellow

# Construct zip filename
ZIP_FILE="catppuccin-${FLAVOR}-${COLOR}-cursors.zip"

# Clean folder name
CLEAN_NAME="Catppuccin-$(tr '[:lower:]' '[:upper:]' <<< ${FLAVOR:0:1})${FLAVOR:1}-$(tr '[:lower:]' '[:upper:]' <<< ${COLOR:0:1})${COLOR:1})"

echo "[+] Installing Catppuccin cursors: $FLAVOR / $COLOR"
sudo mkdir -p "$ICONS_DIR"

# Fetch latest release JSON
ASSETS_JSON="$(curl -s "https://api.github.com/repos/catppuccin/cursors/releases/latest")"

# Get download URL
ASSET_URL=$(echo "$ASSETS_JSON" | jq -r --arg NAME "$ZIP_FILE" '.assets[] | select(.name == $NAME) | .browser_download_url')

if [ -z "$ASSET_URL" ] || [ "$ASSET_URL" == "null" ]; then
    echo "[!] Cursor $ZIP_FILE not found in latest release!"
    exit 1
fi

# Download
file="$TMP_DIR/$ZIP_FILE"
echo "[+] Downloading $ZIP_FILE"
curl -L -o "$file" "$ASSET_URL"

# Extract to icons folder
TARGET_DIR="$ICONS_DIR/$CLEAN_NAME"
sudo rm -rf "$TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"
unzip -q "$file" -d "$TMP_DIR"
sudo cp -r "$TMP_DIR/${ZIP_FILE%.zip}/." "$TARGET_DIR/"

# Cleanup
rm -rf "$TMP_DIR"

echo "[✓] Installed cursors to $TARGET_DIR"
echo "You can set them with GNOME Tweaks → Appearance → Cursor."

