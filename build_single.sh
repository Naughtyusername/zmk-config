#!/bin/bash
# --- Build Single Keyboard ---
# Prompts user to select which keyboard to build (faster than building all)

ZMK_PATH="$HOME/zmk"
CONFIG_PATH="$HOME/qmk/zmk/zmk-config.git/config"
MODULES_PATH="$HOME/qmk/zmk/zmk-config.git/zmk-modules"
EXTRA_MODULES="$MODULES_PATH/zmk-auto-layer;$MODULES_PATH/zmk-leader-key"
BOARD="nice_nano"
DATE_STR=$(date +%Y-%m-%d_%H-%M)
BASE_DEST="$HOME/Downloads/zmk_builds/$DATE_STR"

# --- Menu ---
echo "==============================================="
echo "🛠️  ZMK Single Board Builder"
echo "==============================================="
echo ""
echo "Select a keyboard to build:"
echo ""
echo "  1) Sofle (split)"
echo "  2) Cradio/Sweep (split)"
echo "  3) Bullet Train (standalone)"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        KEYBOARD="sofle"
        BUILD_TYPE="split"
        ;;
    2)
        KEYBOARD="cradio"
        BUILD_TYPE="split"
        ;;
    3)
        KEYBOARD="bullet_train"
        BUILD_TYPE="standalone"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "---------------------------------------"
echo "🛠️  BUILDING $KEYBOARD ($BUILD_TYPE)"
echo "---------------------------------------"

cd "$ZMK_PATH" || exit
source .venv/bin/activate
cd app

if [ "$BUILD_TYPE" = "split" ]; then
    # Build Left
    west build -p always -b "$BOARD" -d "build/$KEYBOARD/left" -- -DSHIELD="${KEYBOARD}_left" -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    if [ $? -ne 0 ]; then
        echo "❌ Left build failed!"
        exit 1
    fi

    # Build Right
    west build -p always -b "$BOARD" -d "build/$KEYBOARD/right" -- -DSHIELD="${KEYBOARD}_right" -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    if [ $? -ne 0 ]; then
        echo "❌ Right build failed!"
        exit 1
    fi

    # Create destination and copy files
    mkdir -p "$BASE_DEST/$KEYBOARD"
    cp "build/$KEYBOARD/left/zephyr/zmk.uf2" "$BASE_DEST/$KEYBOARD/${KEYBOARD}_left.uf2"
    cp "build/$KEYBOARD/right/zephyr/zmk.uf2" "$BASE_DEST/$KEYBOARD/${KEYBOARD}_right.uf2"

else
    # Standalone board
    west build -p always -b "$KEYBOARD" -d "build/$KEYBOARD" -- -DZMK_CONFIG="$CONFIG_PATH" -DZMK_EXTRA_MODULES="$EXTRA_MODULES"
    if [ $? -ne 0 ]; then
        echo "❌ Build failed!"
        exit 1
    fi

    mkdir -p "$BASE_DEST/$KEYBOARD"
    cp "build/$KEYBOARD/zephyr/zmk.uf2" "$BASE_DEST/$KEYBOARD/${KEYBOARD}.uf2"
fi

echo ""
echo "---------------------------------------"
echo "🧹 Cleaning up..."
rm -rf build/

# Desktop Notification (Linux)
if command -v notify-send &>/dev/null; then
    notify-send "ZMK Build Complete" "$KEYBOARD firmware ready in Downloads." -i keyboard
fi

# Sound Alert (System Beep)
echo -e "\a"
echo "✅ BUILD COMPLETE"
echo "📂 Location: $BASE_DEST/$KEYBOARD"
echo ""
