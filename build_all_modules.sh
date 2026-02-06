#!/bin/bash
# --- 1. Configuration ---
ZMK_PATH="$HOME/zmk"
CONFIG_PATH="$HOME/qmk/zmk/zmk-config.git/config"
MODULES_PATH="$HOME/qmk/zmk/zmk-config.git/zmk-modules"
EXTRA_MODULES="$MODULES_PATH/zmk-auto-layer"
BOARD="nice_nano"
DATE_STR=$(date +%Y-%m-%d_%H-%M)
BASE_DEST="$HOME/Downloads/zmk_builds/$DATE_STR"
# --- 2. The Build Function ---
# This takes one argument: the name of the shield (e.g., "sofle" or "cradio")
build_keyboard() {
    local SHIELD=$1
    echo "---------------------------------------"
    echo "🛠️  BUILDING $SHIELD"
    echo "---------------------------------------"
    # Build Left
    west build -p always -b "$BOARD" -d "build/$SHIELD/left" -- -DSHIELD="${SHIELD}_left" -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    # Build Right
    west build -p always -b "$BOARD" -d "build/$SHIELD/right" -- -DSHIELD="${SHIELD}_right" -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    # Create destination and copy files
    mkdir -p "$BASE_DEST/$SHIELD"
    cp "build/$SHIELD/left/zephyr/zmk.uf2" "$BASE_DEST/$SHIELD/${SHIELD}_left.uf2"
    cp "build/$SHIELD/right/zephyr/zmk.uf2" "$BASE_DEST/$SHIELD/${SHIELD}_right.uf2"
}
# --- 3. Execution ---
cd "$ZMK_PATH" || exit
source .venv/bin/activate
cd app
# Build your boards
build_keyboard "sofle"
build_keyboard "cradio"
# --- 4. Cleanup & Notifications ---
echo "---------------------------------------"
echo "🧹 Cleaning up..."
rm -rf build/
# Desktop Notification (Linux)
if command -v notify-send &>/dev/null; then
    notify-send "ZMK Build Complete" "Sofle and Sweep firmware are ready in Downloads." -i keyboard
fi
# Sound Alert (System Beep)
echo -e "\a"
echo "✅ ALL BUILDS COMPLETE"
echo "📂 Location: $BASE_DEST"
