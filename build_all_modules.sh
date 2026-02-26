#!/bin/bash
# --- 1. Configuration ---
ZMK_PATH="$HOME/zmk"
CONFIG_PATH="$HOME/qmk/zmk/zmk-config.git/config"
MODULES_PATH="$HOME/qmk/zmk/zmk-config.git/zmk-modules"
EXTRA_MODULES="$MODULES_PATH/zmk-auto-layer;$MODULES_PATH/zmk-leader-key"
BOARD="nice_nano"
DATE_STR=$(date +%Y-%m-%d_%H-%M)
BASE_DEST="$HOME/Downloads/zmk_builds/$DATE_STR"
# --- 2. Build Functions ---
# Split keyboard function (left/right): takes shield name
build_split_keyboard() {
    local SHIELD=$1
    echo "---------------------------------------"
    echo "🛠️  BUILDING $SHIELD (split)"
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

# Standalone board function (single integrated board): takes board name
build_standalone_board() {
    local BOARD_NAME=$1
    echo "---------------------------------------"
    echo "🛠️  BUILDING $BOARD_NAME (standalone)"
    echo "---------------------------------------"
    west build -p always -b "$BOARD_NAME" -d "build/$BOARD_NAME" -- -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    # Create destination and copy file
    mkdir -p "$BASE_DEST/$BOARD_NAME"
    cp "build/$BOARD_NAME/zephyr/zmk.uf2" "$BASE_DEST/$BOARD_NAME/${BOARD_NAME}.uf2"
}

# Legacy alias for backwards compatibility
build_keyboard() {
    build_split_keyboard "$@"
}
# --- 3. Execution ---
cd "$ZMK_PATH" || exit
source .venv/bin/activate
cd app
# Build split keyboards (left/right pairs)
build_split_keyboard "sofle"
build_split_keyboard "cradio"
# Build standalone boards (single integrated boards)
build_standalone_board "bullet_train"
# --- 4. Cleanup & Notifications ---
echo "---------------------------------------"
echo "🧹 Cleaning up..."
rm -rf build/
# Desktop Notification (Linux)
if command -v notify-send &>/dev/null; then
    notify-send "ZMK Build Complete" "Sofle, Sweep, and Bullet Train firmware ready in Downloads." -i keyboard
fi
# Sound Alert (System Beep)
echo -e "\a"
echo "✅ ALL BUILDS COMPLETE"
echo "📂 Location: $BASE_DEST"
