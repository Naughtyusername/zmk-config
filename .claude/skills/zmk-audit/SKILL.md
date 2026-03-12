---
name: zmk-audit
description: Pre-build validation for ZMK config — checks conventions, macro consistency, and structural errors before compiling
disable-model-invocation: true
allowed-tools: Grep, Read, Glob
---

Audit the ZMK config for convention violations and structural errors. Run ALL checks below and report findings.

## Check 1: Gaming Thumb Clusters — No `&trans`

Gaming layers use `&to` (permanent switch), so `&trans` falls through to BASE where home row mods add latency. Every gaming/roguelike thumb must be explicit.

Search `config/wrappers.dtsi` for these macros and flag any `_______` or `&trans`:
- `___SOFLE_THUMBS_L_GAMING___`, `___SOFLE_THUMBS_R_GAMING___`
- `___SOFLE_THUMBS_L_GAMING2___`, `___SOFLE_THUMBS_R_GAMING2___`
- `___SOFLE_THUMBS_L_ROGUELIKE___`, `___SOFLE_THUMBS_R_ROGUELIKE___`
- `___SWEEP_THUMBS_GAMING___`, `___SWEEP_THUMBS_GAMING2___`, `___SWEEP_THUMBS_ROGUELIKE___`
- `___BT_THUMBS_GAMING___`, `___BT_THUMBS_GAMING2___`, `___BT_THUMBS_ROGUE___`

Severity: **ERROR** — causes input latency on gaming layers that's invisible until you're playing.

## Check 2: Layer Index vs Keymap Order

Read the `#define` block in `config/wrappers.dtsi` (BASE=0 through MOUSE=10).
Count the layer blocks in each `.keymap` file — they MUST appear in the same order as the indices.

For each keymap, verify:
- Layer 0 (first block) = BASE
- Layer 1 = VIM
- Layer 2 = LOWER
- Layer 3 = RAISE
- Layer 4 = FUNC
- Layer 5 = ADJUST
- Layer 6 = GAMING
- Layer 7 = GAMING2
- Layer 8 = ROGUELIKE
- Layer 9 = SYS
- Layer 10 = MOUSE

Severity: **ERROR** — wrong order means layer indices point to the wrong layer. Silent, devastating.

## Check 3: Combo Position Overrides

Extract every combo node name from `config/combos.dtsi` (nodes inside the `combos { }` block).
For each `.keymap` file, verify it has a matching `combo_NAME { key-positions = <...>; }` override.

Flag any combo that exists in `combos.dtsi` but is missing from a keymap.

Severity: **ERROR** — missing override means the combo uses placeholder positions `<0 1>`, firing on the wrong keys.

## Check 4: Undefined Macro References

In each `.keymap` file, find all `___*___` references (the triple-underscore wrapper macros).
Verify each one has a corresponding `#define` in `config/wrappers.dtsi`.

Common typo patterns to watch for:
- `GAMIGN` vs `GAMING`
- `ROGULIKE` vs `ROGUELIKE`
- Missing `_6___` suffix on 6-col boards
- `ROGUE` vs `ROGUELIKE` (BT wrappers use abbreviated `ROGUE`)

Severity: **ERROR** — undefined macro = preprocessor error, but the error message is cryptic.

## Check 5: Layer Completeness

Each keymap should have exactly 11 layer blocks (indices 0-10).
- `sofle.keymap` — 11 layers
- `cradio.keymap` — 11 layers
- `bullet_train.keymap` — 11 layers

Flag any keymap with missing or extra layers.

Severity: **ERROR** — missing layer compiles fine but that layer index does nothing on the keyboard.

## Check 6: Encoder Bindings (Sofle Only)

In `sofle.keymap`, every layer block must have a `sensor-bindings` line.
Each `___ENC_LAYER___` macro in `wrappers.dtsi` should contain exactly 2 `&inc_dec_kp` bindings (left encoder + right encoder).

Check that all 11 `___ENC_*___` macros exist:
`___ENC_BASE___` through `___ENC_MOUSE___`

Also check encoder key macros: `___ENC_KEY_BASE___` through `___ENC_KEY_MOUSE___` (2 keys each).

Severity: **ERROR** — wrong count = compile error pointing at expanded macro (unhelpful).

## Check 7: Thumb Cluster Key Counts

Count the number of key bindings in each thumb macro:
- `___SOFLE_THUMBS_[LR]_*___` — must be exactly 5 each (10 per layer)
- `___SWEEP_THUMBS_*___` — must be exactly 4 total per layer
- `___BT_THUMBS_*___` — must be exactly 9 total per layer

Severity: **ERROR** — wrong count = "expected N bindings, got M" compile error.

## Report Format

```
=== ZMK Config Audit ===

[PASS/FAIL] Check 1: Gaming Thumb Clusters
  (details if FAIL)

[PASS/FAIL] Check 2: Layer Index Order
  (details if FAIL)

... etc ...

Summary: X/7 checks passed, Y errors, Z warnings
Files verified: wrappers.dtsi, combos.dtsi, sofle.keymap, cradio.keymap, bullet_train.keymap
```
