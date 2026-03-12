---
name: zmk-add-combo
description: Guided walkthrough for adding a new combo to the ZMK config
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
---

Guide the user through adding a new combo. Read the current combo state first, then walk through each step.

## Step 1: Gather Requirements

Ask the user:
1. **Trigger keys** — which keys? (by letter, e.g. "W+E" or "J+K+L")
2. **Binding** — what does it do? (keycode like `&kp ESC`, macro like `&macro_parens`, layer switch like `&to GAMING`, one-shot mod like `&skq LSHFT`)
3. **Active layers** — which layers? (e.g. `BASE VIM`, or `GAMING` only)
4. **Timeout tier**:
   - FAST (18ms) — adjacent keys, frequent use, one-shot mods. Uses `COMBO_TERM_FAST`
   - MED (30ms) — standard combos, good balance. Hardcoded `<30>` or use literal
   - SLOW (50ms) — deliberate actions, layer switches. Uses `COMBO_TERM_SLOW`
5. **Does it need `require-prior-idle-ms`?** — Usually yes for FAST tier to prevent misfires during fast typing. Standard value: `<100>`
6. **Does it need `slow-release`?** — Yes for one-shot mods (keeps mod active while next key is held)

## Step 2: Conflict Check

Read `config/combos.dtsi` and check:
- Are any existing combos using the same key positions on overlapping layers?
- Same physical keys can share positions IF their layer lists don't overlap (e.g. Q+W = `!=` on BASE, OSM GUI on VIM)
- If there's a conflict, warn the user and suggest: different layers, different keys, or removing the conflicting combo

## Step 3: Generate the Combo Node

Show the user what to add to `config/combos.dtsi`, placed in the appropriate section:
- Utility combos → after the utility section header
- Auto-pair combos → after the auto-pair section header
- One-shot mods → after the OSM section header
- Layer switching → after the layer switching section header

Template:
```
combo_DESCRIPTIVE_NAME {
    timeout-ms = <COMBO_TERM_TIER>;    // or literal like <30>
    key-positions = <0 1>;              // placeholder — overridden per board
    bindings = <&BINDING>;
    layers = <LAYER1 LAYER2>;
};
```

Add `require-prior-idle-ms = <100>;` and `slow-release;` if applicable.
Use the `combo_name: combo_name { }` label syntax only if the combo needs to be referenced elsewhere.

## Step 4: Generate Position Overrides

Look up positions using the matrix maps in each keymap file's header comments.

**Cradio** (34-key) — `config/cradio.keymap`:
```
 0=Q   1=W   2=E   3=R   4=T |  5=Y   6=U   7=I   8=O   9=P
10=A  11=S  12=D  13=F  14=G | 15=H  16=J  17=K  18=L  19=;
20=Z  21=X  22=C  23=V  24=B | 25=N  26=M  27=,  28=.  29=/
                      30  31 | 32  33     (thumbs)
```

**Sofle** (60-key) — `config/sofle.keymap`:
```
 0   1   2   3   4   5       |       6   7   8   9  10  11    (numrow)
12  13=Q 14=W 15=E 16=R 17=T | 18=Y 19=U 20=I 21=O 22=P  23
24  25=A 26=S 27=D 28=F 29=G | 30=H 31=J 32=K 33=L 34=;  35
36  37=Z 38=X 39=C 40=V 41=B | 42  43  44=N 45=M 46=, 47=. 48=/ 49
            50  51  52  53  54 | 55  56  57  58  59  (thumbs)
```

**Bullet Train** (~51-key) — `config/bullet_train.keymap`:
```
Row 0: 0-5                          (partial numrow: 1-6)
Row 1: 6-17   (ESC Q W E R T | Y U I O P BSPC)
Row 2: 18-29  (TAB A S D F G | H J K L ; RET)
Row 3: 30-41  (SHFT Z X C V B | N M , . UP /)
Row 4: 42-50  (LCTL LGUI LALT | SPC1 SPC2 SPC3 | LEFT DOWN RIGHT)
```

Show the override block for each keymap:
```
// In config/BOARD.keymap, inside combos { }:
combo_DESCRIPTIVE_NAME {
    key-positions = <POS1 POS2>;  // LETTER1 + LETTER2
};
```

## Step 5: Update the Combo Index Table

Remind the user to add an entry to the ASCII reference table at the top of `combos.dtsi`:
```
//  │ COMBO_NAME            │ KEYS │ Output     │ Timing  │ Layers           │
```

## Step 6: Summary Checklist

Present a checklist:
- [ ] Combo node added to `config/combos.dtsi`
- [ ] Position override added to `config/sofle.keymap`
- [ ] Position override added to `config/cradio.keymap`
- [ ] Position override added to `config/bullet_train.keymap`
- [ ] Combo index table updated in `combos.dtsi`
- [ ] No position conflicts on overlapping layers
