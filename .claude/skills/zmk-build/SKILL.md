---
name: zmk-build
description: Build ZMK firmware for a specific keyboard or all keyboards
disable-model-invocation: true
argument-hint: sofle|cradio|bullet_train|all
allowed-tools: Bash(west *), Bash(cd *), Bash(source *), Bash(mkdir *), Bash(cp *), Bash(date *), Bash(ls *), Read
---

Build ZMK firmware. Parse `$ARGUMENTS` to determine target:

- `/zmk-build sofle` — build left + right halves
- `/zmk-build cradio` — build left + right halves
- `/zmk-build bullet_train` — build standalone
- `/zmk-build all` — build sofle, cradio, and bullet_train

If `$ARGUMENTS` is empty or unrecognized, ask the user which keyboard to build.

## Build Environment

```
ZMK_PATH=$HOME/dev/firmware/zmk
CONFIG_PATH=$HOME/dev/firmware/zmk-config.git/config
MODULES_PATH=$HOME/dev/firmware/zmk-config.git/zmk-modules
EXTRA_MODULES=$MODULES_PATH/zmk-auto-layer;$MODULES_PATH/zmk-leader-key
BOARD=nice_nano
```

## Build Commands

First activate the environment:
```bash
cd $HOME/dev/firmware/zmk && source .venv/bin/activate && cd app
```

**Split keyboards (sofle, cradio):**
```bash
west build -p always -b nice_nano -d build/KEYBOARD/left -- \
  -DSHIELD="KEYBOARD_left" \
  -DZMK_CONFIG="$HOME/dev/firmware/zmk-config.git/config" \
  -DZMK_EXTRA_MODULES="$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-auto-layer;$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-leader-key"

west build -p always -b nice_nano -d build/KEYBOARD/right -- \
  -DSHIELD="KEYBOARD_right" \
  -DZMK_CONFIG="$HOME/dev/firmware/zmk-config.git/config" \
  -DZMK_EXTRA_MODULES="$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-auto-layer;$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-leader-key"
```

**Standalone (bullet_train):**
```bash
west build -p always -b bullet_train -d build/bullet_train -- \
  -DZMK_CONFIG="$HOME/dev/firmware/zmk-config.git/config" \
  -DZMK_EXTRA_MODULES="$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-auto-layer;$HOME/dev/firmware/zmk-config.git/zmk-modules/zmk-leader-key"
```

## After Build

On success:
1. Create output directory: `~/Downloads/zmk_builds/YYYY-MM-DD_HH-MM/KEYBOARD/`
2. Copy `.uf2` files from `build/KEYBOARD/[left|right]/zephyr/zmk.uf2`
3. Report the output path and file sizes

On failure:
1. Show the full error output
2. **Trace macro errors**: If the compiler error references a line in an expanded macro, read `config/wrappers.dtsi` and identify which `#define` wrapper contains the problematic binding. Report the wrapper name and line, not the expanded output.
3. Suggest a fix based on common patterns:
   - "undefined identifier" → typo in macro name, search wrappers.dtsi for similar names
   - "expected N bindings, got M" → wrong key count in a wrapper macro, count keys in the define
   - "unknown behavior" → missing `#include` or typo in behavior name
   - "devicetree error" → structural issue in keymap (missing semicolons, unclosed braces)

When building `all`, continue building remaining keyboards even if one fails. Report results for each.
