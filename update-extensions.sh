#!/usr/bin/env sh
# ============================================
# ChillSubs extensions - download / update (macOS / Linux)
# ============================================
# Downloads the latest zip, removes the old copies and extracts the new ones to:
#   ~/chillsubs-extensions/pagecrawl-lookup
#   ~/chillsubs-extensions/submittable-importer
# First time: chrome://extensions -> Developer mode -> Load unpacked -> pick each folder.
# After updates: click the reload icon on each extension in chrome://extensions.

set -e

ZIP_URL="https://raw.githubusercontent.com/niyatimadaan/extension-releases/main/chillsubs-extensions.zip"
INSTALL_DIR="$HOME/chillsubs-extensions"
TMP_ZIP="$(mktemp -t chillsubs-extensions.XXXXXX).zip"
trap 'rm -f "$TMP_ZIP"' EXIT

echo "Downloading latest extensions..."
if ! curl -fL --retry 3 -o "$TMP_ZIP" "$ZIP_URL"; then
  echo "Download failed. Existing extensions were left untouched."
  exit 1
fi

mkdir -p "$INSTALL_DIR"

echo "Removing old versions..."
rm -rf "$INSTALL_DIR/pagecrawl-lookup" "$INSTALL_DIR/submittable-importer" "$INSTALL_DIR/VERSION.txt"

echo "Extracting..."
unzip -q -o "$TMP_ZIP" -d "$INSTALL_DIR"

echo
echo "Done. Extensions are in: $INSTALL_DIR"
[ -f "$INSTALL_DIR/VERSION.txt" ] && echo "Build: $(cat "$INSTALL_DIR/VERSION.txt")"
echo "Now open chrome://extensions and click reload on both extensions."
echo "(First time: enable Developer mode, then \"Load unpacked\" and pick each folder.)"
