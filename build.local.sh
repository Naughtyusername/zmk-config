#!/bin/bash

# --- Configuration ---
ZMK_PATH="$HOME/zmk"
CONFIG_PATH="$HOME/qmk/zmk/zmk-config.git"
BOARD="nice_nano"
# Create a folder in Downloads named after today's date
DATE_STR=$(date +%Y-%m-%d_%H-%M)
DEST_DIR="$HOME/Downloads/zmk_builds/sofle_$DATE_STR"

echo "🚀 Starting ZMK Local Build..."

# 1. Navigate and activate environment
cd "$ZMK_PATH" || exit
source .venv/bin/activate
cd app

# 2. Build Left Side
echo "📦 Building Left Side..."
west build -p always -b "$BOARD" -d build/left -- -DSHIELD=sofle_left -DZMK_CONFIG="$CONFIG_PATH"

# 3. Build Right Side
echo "📦 Building Right Side..."
west build -p always -b "$BOARD" -d build/right -- -DSHIELD=sofle_right -DZMK_CONFIG="$CONFIG_PATH"

# 4. Prepare Destination
mkdir -p "$DEST_DIR"

# 5. Copy and Rename
cp build/left/zephyr/zmk.uf2 "$DEST_DIR/sofle_left.uf2"
cp build/right/zephyr/zmk.uf2 "$DEST_DIR/sofle_right.uf2"

# 6. Cleanup (Optional: Removes the build folders to save space)
echo "🧹 Cleaning up build artifacts..."
rm -rf build/left build/right

echo "---------------------------------------"
echo "✅ Done! Firmware moved to: $DEST_DIR"
