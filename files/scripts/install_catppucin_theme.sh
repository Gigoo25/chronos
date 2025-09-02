#!/usr/bin/env bash
set -euo pipefail

THEMES_DIR="/usr/share/themes"
TMP_DIR="$(mktemp -d)"

# ===============================
# User-configurable variables
# ===============================
FLAVOR="mocha"   # latte | frappe | macchiato | mocha
COLOR="lavender" # blue | flamingo | green | lavender | maroon | mauve | peach | pink | red | rosewater | sapphire | sky | teal | yellow

# Original zip filename
THEME_FILE="catppuccin-${FLAVOR}-${COLOR}-standard+default.zip"

# Clean folder name for GNOME Tweaks
CLEAN_THEME_NAME="Catppuccin-$(tr '[:lower:]' '[:upper:]' <<< ${FLAVOR:0:1})${FLAVOR:1}-$(tr '[:lower:]' '[:upper:]' <<< ${COLOR:0:1})${COLOR:1})"

echo "[+] Installing Catppuccin GTK theme: $FLAVOR / $COLOR"
sudo mkdir -p "$THEMES_DIR"

# Fetch latest release JSON directly from repo
ASSETS_JSON="$(curl -s "https://api.github.com/repos/catppuccin/gtk/releases/latest")"

# Match asset by name (handles '+' safely)
ASSET_URL=$(echo "$ASSETS_JSON" | jq -r --arg NAME "$THEME_FILE" '.assets[] | select(.name == $NAME) | .browser_download_url')

if [ -z "$ASSET_URL" ] || [ "$ASSET_URL" == "null" ]; then
    echo "[!] Theme $THEME_FILE not found in latest release!"
    exit 1
fi

# Download
file="$TMP_DIR/$THEME_FILE"
echo "[+] Downloading $THEME_FILE"
curl -L -o "$file" "$ASSET_URL"

# Extract only gtk-3.0 and gtk-4.0
echo "[+] Extracting gtk-3.0 and gtk-4.0..."
unzip -q "$file" -d "$TMP_DIR"

# Copy only gtk-3.0 and gtk-4.0 to clean folder
TARGET_DIR="$THEMES_DIR/$CLEAN_THEME_NAME"
sudo rm -rf "$TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"

for sub in gtk-3.0 gtk-4.0; do
    [ -d "$TMP_DIR/${THEME_FILE%.zip}/$sub" ] && sudo cp -r "$TMP_DIR/${THEME_FILE%.zip}/$sub" "$TARGET_DIR/"
done

# Cleanup
rm -rf "$TMP_DIR"

echo "[✓] Installed $TARGET_DIR (gtk-3.0 + gtk-4.0)"
echo "Open GNOME Tweaks → Appearance → Applications to apply."

