# My Personal ZMK Keyboard Firmware

This repository contains my personal ZMK firmware configuration for my split ergonomic keyboards. The goal is to create a highly efficient and comfortable typing experience by porting and refining features from my long-standing QMK setup.

This configuration is built with a "write once, run anywhere" philosophy, using a shared set of wrappers and behaviors that are applied to multiple keyboards.

## Features

This firmware is more than just a keymap; it's a finely-tuned typing system. Here are some of the key features:

### Advanced Home Row Mods

Getting home row mods to feel right is critical. This configuration uses a combination of ZMK's most advanced `hold-tap` features to make them responsive and prevent misfires:

-   **Balanced Flavor (`flavor = "balanced"`):** The equivalent of QMK's `PERMISSIVE_HOLD`, this allows for comfortable and fast typing rolls without accidentally triggering modifiers.
-   **Speculative Hold (`hold-while-undecided`):** Reduces latency on held modifiers by speculatively assuming a hold action.
-   **Idle-Priority Holds (`require-prior-idle-ms = <150>`):** The equivalent of QMK's `FLOW_TAP_TERM`. This feature prevents accidental holds during fast typing by requiring a brief pause before a `hold-tap` key can register as "held".
-   **Quick Tap (`quick-tap-ms = <175>`):** Prevents a hold from triggering on a rapid double-tap of a key.

### Custom Key-Behaviors and Macros

-   **Shift + Backspace = Delete:** A `mod-morph` behavior provides `Delete` functionality without needing a dedicated key.
-   **`CAPS_WORD` Combo:** `CAPS_WORD` is enabled via a two-key combo, providing a more ergonomic alternative to Caps Lock.
-   **Programming Macros:** Several macros for common programming operators are included:
    -   `:=` (`&assign`)
    -   `->` (`&arrow`)
    -   `::` (`&double_colon`)
    -   `..=` (`&range`)
    -   `~/` (`&hmdr`)

### Advanced Layer Management

-   **Tri-Layer:** Activating the `LOWER` and `RAISE` layers simultaneously enters a third `ADJUST` layer for system-level commands. This is implemented using ZMK's `conditional_layers`.
-   **Wrapper-Based Layouts:** The keymap is defined using a system of `dtsi` wrappers, inspired by QMK's `#define` wrapper system. This allows for a clean separation between the core layout and keyboard-specific physical layouts.

## Supported Keyboards

This configuration is currently set up to build for the following keyboards:

-   **Cradio (Ferris/Sweep like)**
-   **Sofle**
-   **Corne**

## Layouts

The layout is based on a 3x5 grid with extensive use of layers and combos to maintain functionality on a small footprint.

*(ASCII layout representation can be added here if desired)*

### Layers

-   **Base Layer:** QWERTY layout with home row mods.
-   **Lower Layer:** Numbers (as a numpad on the right hand), and media keys.
-   **Raise Layer:** Symbols and punctuation, optimized for programming.
-   **Function Layer:** F-keys and navigation.
-   **Adjust Layer (Tri-Layer):** System controls, firmware settings, and layer toggles.
-   **Gaming Layer:** A layer with home row mods disabled for compatibility.
-   **roguelike Layer:** A layer with home row mods disabled for compatibility.
-   **system Layer:** A layer to toggle bluetooth, firmware reboot and bootloaders.

## Building The Firmware

### Using GitHub Actions (Not my favorite, too slow. great if you have a full config written tho.)

The easiest way to build the firmware is to use the included GitHub Actions workflow.

1.  **Push to GitHub:** Commit and push your changes to your GitHub repository.
2.  **Trigger the Build:** The build workflow will automatically run.
3.  **Download the Firmware:** Once the build is complete, go to the "Actions" tab in your GitHub repository, find the completed workflow run, and download the firmware artifact. The artifact will be a ZIP file containing the `uf2` files for each keyboard half.

### Local Building

To build the firmware locally, you will need to have a ZMK development environment set up.

1.  **Setup ZMK:** Follow the official ZMK documentation to set up the toolchain.
2.  **Initialize West:** If you have cloned this repository fresh, you need to initialize the ZMK modules:
    ```bash
    west init -l config
    west update
    ```
3.  **Build:** Use the `build.local.sh` script (or run the `west build` command manually). For example, to build for the Sofle keyboard:
    ```bash
    # For left hand
    west build -d build/left -b nice_nano -- -DSHIELD=sofle_left
    # For right hand
    west build -d build/right -b nice_nano -- -DSHIELD=sofle_right
    ```

You can then find the `zmk.uf2` file in the `build/left` or `build/right` directory.
