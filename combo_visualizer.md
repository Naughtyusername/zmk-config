# Cradio Combo Visualizer

This document provides a visual reference for the combos defined in your ZMK configuration for the 34-key Cradio/Sweep layout. This version uses a precise, explicit connector and label placement style based on your feedback.

---

### Diagram 1: Navigation & Core Combos

This diagram shows your primary home-row combos for core actions.

```
  ╭───────────────────────────┬───────────────────────────╮   ╭───────────────────────────┬───────────────────────────╮
  │     Q      W      E      R      T     │   │     Y      U      I      O      P     │
  │                                       │   │                                       │
  │     A      S------D------F------G     │   │     H------J------K      L------;     │
  │            | BSPC || TAB ||  _   |     │   │    | CAPS || ESC ||      | ENT  |     │
  │            `------''------''------'     │   │    `------''------'      `------'     │
  │                                       │   │                                       │
  │     Z      X      C      V      B     │   │     N      M      ,      .      /     │
  ╰───────────╮                       ╭───╯   ╰───╮                       ╭───────────╯
              │      BSPC   SPACE     │           │      ENT     TAB      │
              ╰───────────────────────╯           ╰───────────────────────╯
```

---

### Diagram 2: One-Shot GACS Mods (Mirrored)

This diagram shows the top-row combos for one-shot modifiers, correctly paired across the keyboard using the new style.

```
  ╭───────────────────────────┬───────────────────────────╮   ╭───────────────────────╮
  │     Q------W------E------R------T     │   │     Y------U------I------O------P     │
  │    | L-GUI || L-ALT || L-CTL || L-SFT |   │    | R-SFT || R-CTL || R-ALT || R-GUI |
  │    `------''------''------''------'     │   │    `------''------''------''------' │
  │                                       │   │                                       │
  │     A      S      D      F      G     │   │     H      J      K      L      ;     │
  │                                       │   │                                       │
  │     Z      X      C      V      B     │   │     N      M      ,      .      /     │
  ╰───────────╮                       ╭───╯   ╰───╮                       ╭───────────╯
              │      BSPC   SPACE     │           │      ENT     TAB      │
              ╰───────────────────────╯           ╰───────────────────────╯
```

---

### Diagram 3: Auto-Pairing Combos

This diagram shows the bottom-row and cross-row combos for auto-pairing brackets and quotes, using the new style where possible.

```
  ╭───────────────────────────┬───────────╮   ╭───────────────────────────────────────╮
  │     Q      W      E      R      T     │   │     Y      U      I      O      P     │
  │                                       │   │                                       │
  │     A      S      D      F      G     │   │     H      J      K      L      ;     │
  │                                       │   │    /''  /""                           │
  │                                       │   │   J/    K/                            │
  │                                       │   │   M     ,                             │
  │     Z      X      C      V      B     │   │     N------M------,------.      /     │
  │                                       │   │    | () || [] || {} |                 │
  │                                       │   │    `------''------''------'           │
  ╰───────────╮                       ╭───╯   ╰───╮                       ╭───────────╯
              │      BSPC   SPACE     │           │      ENT     TAB      │
              ╰───────────────────────╯           ╰───────────────────────╯
```
