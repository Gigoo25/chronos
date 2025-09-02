#!/usr/bin/env bash
set -euo pipefail

ICONS_DIR="/usr/share/icons"
TMP_DIR="$(mktemp -d)"

# ===============================
# User-configurable variables
# ===============================
FLAVOR="mocha"   # latte | frappe | macchiato | mocha
COLOR="lavender" # blue | flamingo | green | lavender | maroon | mauve | peach | pink | red | rosewater | sapphire | sky | teal | yellow

# Construct folder color name
FOLDER_COLOR="cat-${FLAVOR}-${COLOR}"

echo "[+] Installing Catppuccin Papirus folders: $FOLDER_COLOR"

# Clone the repository
echo "[+] Cloning papirus-folders repository..."
git clone https://github.com/catppuccin/papirus-folders.git "$TMP_DIR/papirus-folders"
cd "$TMP_DIR/papirus-folders"

# Define target folders / themes
TARGET_FOLDERS=("Papirus" "Papirus-Dark")

# Copy src content to both Papirus folders
for TARGET in "${TARGET_FOLDERS[@]}"; do
  DEST="$ICONS_DIR/$TARGET"
  echo "[+] Copying folder icons to $DEST..."
  sudo mkdir -p "$DEST"
  sudo cp -r src/* "$DEST/"
done

# Cleanup
rm -rf "$TMP_DIR"

echo "[✓] Installed Catppuccin Papirus folders with color $FOLDER_COLOR to both Papirus and Papirus-Dark."
echo "You can change colors later with: sudo papirus-folders -C <color> --theme <theme>"
