---
name: zmk-add-layer
description: Guided walkthrough for adding a new layer to the ZMK config
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
---

Guide the user through adding a new layer. Read current state first, then walk through every required change.

## Step 1: Gather Requirements

Ask the user:
1. **Layer name** — what to call it (e.g. MEDIA, NUMPAD, ARROWS)
2. **Purpose** — what keys go on it
3. **Which keyboards** — Sofle, Cradio, Bullet Train, or all three?
4. **Home row mods?** — Gaming-adjacent layers should NOT have HRM
5. **Switching method** — How to enter/exit:
   - `&mo` (momentary, release to exit)
   - `&lt` (layer-tap: hold=layer, tap=keycode)
   - `&to` (permanent switch, need combo or key to exit)
   - `&tog` (toggle on/off)
   - Conditional/tri-layer (activated by holding two layers)
   - Combo (3-finger switch)

## Step 2: Determine Layer Index

Read `config/wrappers.dtsi` and find the current highest layer index.
New layer = highest + 1 (currently MOUSE=10, so next would be 11).

**IMPORTANT**: Layer order in keymaps must match define order. The new layer goes AFTER all existing layers.

## Step 3: Walk Through All Required Changes

### 3a. Layer Index Define — `config/wrappers.dtsi`

Add after the last `#define` in the layer index block:
```c
#define NEWLAYER   11
```

### 3b. Core 5-Column Macros — `config/wrappers.dtsi`

Add a comment block following the existing format, then 6 macros:
```c
/* --------------------------------------------------------------------------
 * NEWLAYER LAYER - Description
 * --------------------------------------------------------------------------
 *  _     _     _     _     _          _     _     _     _     _
 *  _     _     _     _     _          _     _     _     _     _
 *  _     _     _     _     _          _     _     _     _     _
 */
#define ___NEWLAYER_L1___ ...5 keys...
#define ___NEWLAYER_L2___ ...5 keys...
#define ___NEWLAYER_L3___ ...5 keys...
#define ___NEWLAYER_R1___ ...5 keys...
#define ___NEWLAYER_R2___ ...5 keys...
#define ___NEWLAYER_R3___ ...5 keys...
```

### 3c. Number Row Macros (if Sofle or BT needs it) — `config/wrappers.dtsi`

5-col base + 6-col expansion:
```c
#define ___NUM_NEWLAYER_L___    _______ _______ _______ _______ _______
#define ___NUM_NEWLAYER_R___    _______ _______ _______ _______ _______
#define ___NUM_NEWLAYER_L_6___  _______ ___NUM_NEWLAYER_L___
#define ___NUM_NEWLAYER_R_6___  ___NUM_NEWLAYER_R___ _______
```

### 3d. 6-Column Expansion Macros (Sofle + BT) — `config/wrappers.dtsi`

```c
#define ___NEWLAYER_L1_6___ OUTER_L ___NEWLAYER_L1___
#define ___NEWLAYER_L2_6___ OUTER_L ___NEWLAYER_L2___
#define ___NEWLAYER_L3_6___ OUTER_L ___NEWLAYER_L3___
#define ___NEWLAYER_R1_6___ ___NEWLAYER_R1___ OUTER_R
#define ___NEWLAYER_R2_6___ ___NEWLAYER_R2___ OUTER_R
#define ___NEWLAYER_R3_6___ ___NEWLAYER_R3___ OUTER_R
```

Outer column keys depend on layer purpose. Check existing layers for patterns:
- BASE: ESC/TAB/LGUI on left, BSPC/SQT/RGUI on right
- Gaming: TAB/LCTRL/LSHFT on left
- Most others: `_______` for transparent

### 3e. Sofle Thumb Clusters — `config/wrappers.dtsi`

```c
#define ___SOFLE_THUMBS_L_NEWLAYER___ (5 keys)
#define ___SOFLE_THUMBS_R_NEWLAYER___ (5 keys)
```

**CRITICAL**: If this is a gaming-adjacent layer accessed via `&to`, use explicit `&kp` keys. Never `&trans`.

### 3f. Sweep Thumb Cluster — `config/wrappers.dtsi`

```c
#define ___SWEEP_THUMBS_NEWLAYER___ (4 keys total: 2 left + 2 right)
```

Same `&trans` rule applies for gaming layers.

### 3g. Encoder Bindings (Sofle only) — `config/wrappers.dtsi`

```c
#define ___ENC_NEWLAYER___     &inc_dec_kp C_VOL_UP C_VOL_DN    &inc_dec_kp PG_UP PG_DN
#define ___ENC_KEY_NEWLAYER___ _______ _______
```

### 3h. Bullet Train Wrappers (if BT needs it) — `config/wrappers.dtsi`

BT has custom wrappers for several rows. All of these need a NEWLAYER variant:
```c
#define ___BT_NUMROW_NEWLAYER___   _______ _______ _______ _______ _______ _______
#define ___BT_NEWLAYER_R2_6___     ___NEWLAYER_R2___ _______
#define ___BT_NEWLAYER_L3_6___     &kp LSHFT ___NEWLAYER_L3___
#define ___BT_NEWLAYER_R3_6___     (6 keys — manually expand, UP at position 10)
#define ___BT_THUMBS_NEWLAYER___   (9 keys total)
```

Check existing BT wrappers for the exact pattern — Row 3 right side embeds UP before SLASH.

### 3i. Layer Block in Each Keymap

Add as the LAST layer block (position must match the `#define` index).

**Sofle** (`config/sofle.keymap`):
```
newlayer {
    display-name = "NEWLAYER";
    bindings = <
          ___NUM_NEWLAYER_L_6___                   ___NUM_NEWLAYER_R_6___
          ___NEWLAYER_L1_6___                    ___NEWLAYER_R1_6___
          ___NEWLAYER_L2_6___                    ___NEWLAYER_R2_6___
          ___NEWLAYER_L3_6___ ___ENC_KEY_NEWLAYER___ ___NEWLAYER_R3_6___
        ___SOFLE_THUMBS_L_NEWLAYER___ ___SOFLE_THUMBS_R_NEWLAYER___
    >;
         sensor-bindings = <___ENC_NEWLAYER___>;
};
```

**Cradio** (`config/cradio.keymap`):
```
newlayer_layer {
    bindings = <
        ___NEWLAYER_L1___ ___NEWLAYER_R1___
        ___NEWLAYER_L2___ ___NEWLAYER_R2___
        ___NEWLAYER_L3___ ___NEWLAYER_R3___
          ___SWEEP_THUMBS_NEWLAYER___
    >;
};
```

**Bullet Train** (`config/bullet_train.keymap`):
```
NEWLAYER_layer {
    display-name = "NewLayer";
    bindings = <
        ___BT_NUMROW_NEWLAYER___
        ___NEWLAYER_L1_6___        ___NEWLAYER_R1_6___
        ___NEWLAYER_L2_6___        ___BT_NEWLAYER_R2_6___
        ___BT_NEWLAYER_L3_6___     ___BT_NEWLAYER_R3_6___
        ___BT_THUMBS_NEWLAYER___
    >;
};
```

### 3j. Layer Switching

Depending on the chosen method:
- **Combo**: Add to `combos.dtsi` + position overrides in all 3 keymaps (use `/zmk-add-combo` skill)
- **Key binding**: Modify an existing thumb cluster or key in `wrappers.dtsi`
- **Conditional layer**: Add to `conditional_layers` block in `behaviors.dtsi`

### 3k. Update Existing Combos (if needed)

If any existing combos should also be active on this new layer, update their `layers` list in `combos.dtsi`.

## Step 4: Verification Checklist

Present the full checklist grouped by file:

**config/wrappers.dtsi:**
- [ ] `#define NEWLAYER N` added to layer index block
- [ ] 6 core 5-col macros (`___NEWLAYER_[LR][123]___`)
- [ ] 4 number row macros (5-col + 6-col)
- [ ] 6 expansion macros (`___NEWLAYER_[LR][123]_6___`)
- [ ] Sofle thumb macros (L + R, 5 keys each)
- [ ] Sweep thumb macro (4 keys total)
- [ ] Encoder rotation macro (2 bindings)
- [ ] Encoder key macro (2 keys)
- [ ] BT numrow macro (6 keys) — if BT needs it
- [ ] BT row 2 right, row 3 left/right macros — if BT needs it
- [ ] BT thumb macro (9 keys) — if BT needs it

**config/sofle.keymap:**
- [ ] Layer block added at correct position (index N)
- [ ] Uses `_6___` macros + encoder bindings

**config/cradio.keymap:**
- [ ] Layer block added at correct position (index N)
- [ ] Uses 5-col macros + sweep thumbs

**config/bullet_train.keymap:**
- [ ] Layer block added at correct position (index N)
- [ ] Uses `___BT_*___` macros

**config/combos.dtsi or behaviors.dtsi:**
- [ ] Layer switching mechanism added (if needed)
- [ ] Existing combo layer lists updated (if needed)
- [ ] Conditional layer added (if tri-layer)
