#!/bin/bash

# --- 1. Configuration ---
ZMK_PATH="$HOME/zmk"
CONFIG_PATH="$HOME/qmk/zmk/zmk-config.git/config"
# ADD THIS: Path to your cloned zmk-helpers repository
HELPERS_PATH="$HOME/qmk/zmk/zmk-config.git/zmk-modules/zmk-helpers"
# ^ this points to the root of that module but we cp part of the headers into our config. address later if it becomes an issue
BOARD="nice_nano"
DATE_STR=$(date +%Y-%m-%d_%H-%M)
BASE_DEST="$HOME/Downloads/zmk_builds/$DATE_STR"

# --- 2. The Build Function ---
build_keyboard() {
    local SHIELD=$1
    echo "---------------------------------------"
    echo "🛠️  BUILDING $SHIELD"
    echo "---------------------------------------"

    # UPDATED: Added -DZMK_EXTRA_MODULES to include zmk-helpers
    # Build Left
    west build -p always -b "$BOARD" -d "build/$SHIELD/left" -- \
        -DSHIELD="${SHIELD}_left" \
        -DZMK_CONFIG="$CONFIG_PATH" \
        -DZMK_EXTRA_MODULES="$HELPERS_PATH"

    # Build Right
    west build -p always -b "$BOARD" -d "build/$SHIELD/right" -- \
        -DSHIELD="${SHIELD}_right" \
        -DZMK_CONFIG="$CONFIG_PATH" \
        -DZMK_EXTRA_MODULES="$HELPERS_PATH"

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
