// clang-format off
#pragma once

// --- SOFLE MAPPING ---
#if defined(SHIELD_SOFLE_LEFT) || defined(SHIELD_SOFLE_RIGHT)
    #define LAYOUT_36( \
        k00, k01, k02, k03, k04,    k05, k06, k07, k08, k09, \
        k10, k11, k12, k13, k14,    k15, k16, k17, k18, k19, \
        k20, k21, k22, k23, k24,    k25, k26, k27, k28, k29, \
                  k30, k31, k32,    k33, k34, k35 \
    ) \
    &none &none &none &none &none &none                        &none &none &none &none &none &none \
    &none k00   k01   k02   k03   k04                              k05   k06   k07   k08   k09   &none \
    &none k10   k11   k12   k13   k14                              k15   k16   k17   k18   k19   &none \
    &none k20   k21   k22   k23   k24   &none                &none k25   k26   k27   k28   k29   &none \
                      k30   k31   k32   &none                &none k33   k34   k35

// --- CRADIO / SWEEP MAPPING ---
#else
    #define LAYOUT_36( \
        k00, k01, k02, k03, k04,    k05, k06, k07, k08, k09, \
        k10, k11, k12, k13, k14,    k15, k16, k17, k18, k19, \
        k20, k21, k22, k23, k24,    k25, k26, k27, k28, k29, \
                  k30, k31, k32,    k33, k34, k35 \
    ) \
    k00 k01 k02 k03 k04    k05 k06 k07 k08 k09 \
    k10 k11 k12 k13 k14    k15 k16 k17 k18 k19 \
    k20 k21 k22 k23 k24    k25 k26 k27 k28 k29 \
            k30 k31 k32    k33 k34 k35
#endif

// The wrapper macro
#define ZMK_LAYER(name, layout_macro) \
    name { \
        bindings = <layout_macro>; \
    };
