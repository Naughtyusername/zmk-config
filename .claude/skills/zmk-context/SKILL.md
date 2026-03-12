---
name: zmk-context
description: Load ZMK keyboard firmware context when discussion involves layers, keymaps, combos, behaviors, wrappers, thumb clusters, encoders, key bindings, or macros in this zmk-config repository
disable-model-invocation: false
allowed-tools: Read, Glob, Grep
---

Load the ZMK config context by reading key structural files. Internalize this reference — do NOT dump it to the user unless they ask.

**Step 1: Read core files for current state**
- `config/wrappers.dtsi` — layer index `#define` block (lines 32-42), all macro definitions
- `config/combos.dtsi` — combo index table, timeout tier defines (FAST=18, MED=30, SLOW=50)
- `config/behaviors.dtsi` — behavior definitions, macros, conditional layers

**Step 2: Internalize this reference**

Layer indices (defined in wrappers.dtsi, order matters in keymaps):
| Index | Name      | Purpose                                    |
|-------|-----------|--------------------------------------------|
| 0     | BASE      | QWERTY + home row mods (daily driver)      |
| 1     | VIM       | Plain QWERTY, no HRM (vimium, editors)     |
| 2     | LOWER     | Left=symbols (mirror RAISE), Right=numpad  |
| 3     | RAISE     | Symbols (programming-focused)              |
| 4     | FUNC      | F-keys + navigation                        |
| 5     | ADJUST    | Tri-layer (LOWER+RAISE), media, caps/num   |
| 6     | GAMING    | Plain QWERTY, no HRM, explicit thumbs      |
| 7     | GAMING2   | F-keys/numbers overlay for gaming           |
| 8     | ROGUELIKE | Gaming + numpad right hand                  |
| 9     | SYS       | Bluetooth, bootloader, system reset         |
| 10    | MOUSE     | Mouse keys for trackpad use                 |

Macro naming convention:
- 5-col core: `___LAYER_ROW_SIDE___` (e.g. `___BASE_L1___`, `___GAMING_R3___`)
- 6-col expansion: `___LAYER_ROW_SIDE_6___` (adds outer column key)
- Number row: `___NUM_LAYER_SIDE___` / `___NUM_LAYER_SIDE_6___`
- Sofle-specific: `___SOFLE_GAMING2_*___` (Sofle has different GAMING2 since it has numrow)
- Bullet Train: `___BT_*___` prefix for BT-specific rows/thumbs

Keyboards and structure:
- **Sofle** (60 keys): numrow(12) + 3 rows of 6-col(36) + encoders(2) + thumbs(10). Uses `_6___` macros, `___ENC_*___`, `___SOFLE_THUMBS_*___`
- **Cradio/Sweep** (34 keys): 3 rows of 5-col(30) + thumbs(4). Uses base `___` macros, `___SWEEP_THUMBS_*___`
- **Bullet Train** (~51 keys): partial numrow(6) + 3 rows of 6-col(36) + thumb/nav cluster(9). Uses `___BT_*___` macros

Gaming layer rules (CRITICAL):
- All gaming combos use `&to` (permanent layer switch)
- `&trans` in a `&to`-switched layer resolves against BASE, which has HRM latency
- **Every gaming/roguelike thumb cluster must use explicit `&kp`/`&lt`/`&to` — never `&trans`**
- Shift lives on outer pinky column (bottom row) for all 3 gaming layers

Combo system:
- Combos defined in `combos.dtsi` with placeholder `key-positions = <0 1>`
- Each `.keymap` overrides `key-positions` for its board's matrix
- Timeout tiers: FAST(18ms) for OSM/frequent, MED(30ms) for standard, SLOW(50ms) for deliberate/layer-switch
- Some combos share physical positions but are layer-filtered (e.g. Q+W = `!=` on BASE, OSM GUI on VIM)

Key behaviors (from behaviors.dtsi):
- `&hml`/`&hmr` — home row mods (balanced, 175ms tapping-term, positional)
- `&bs_del` — mod-morph: tap=BSPC, shift+tap=DEL
- `&lt_1s_mo` — hold-tap: 1s hold=momentary layer, tap=keycode
- `&skq` — sticky key with quick-release (for OSM combos)
- `&num_word` — auto-layer that stays on LOWER while typing numbers
- `&better_caps_word` — caps word with expanded continue-list
- `&leader` — leader key sequences (EM=email, GHN=github, SH=shebang)

File responsibilities:
| File | Owns |
|------|------|
| `wrappers.dtsi` | Layer indices, all key macros, thumb clusters, encoders |
| `combos.dtsi` | Combo definitions (bindings, timeouts, layers). Positions are placeholders |
| `behaviors.dtsi` | HRM, mod-morphs, macros, leader, conditional layers |
| `secrets.dtsi` | Private macros (email address) |
| `sofle.keymap` | Sofle combo positions, layer assembly with `_6___` + encoder macros |
| `cradio.keymap` | Cradio combo positions, layer assembly with 5-col macros |
| `bullet_train.keymap` | BT combo positions, layer assembly with `___BT_*___` macros |
| `build_single.sh` | Interactive single-board build script |
| `build_all.sh` | Batch build (sofle + cradio) |
| `build.yaml` | GitHub Actions build matrix |

**Step 3: Read files relevant to the user's specific question before responding.**
