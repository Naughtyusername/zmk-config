/* clang-format off */
/* clang-format off */
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
#elif defined(SHIELD_CRADIO_LEFT) || defined(SHIELD_CRADIO_RIGHT) || defined(SHIELD_SWEEP)

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

// --- UROB-STYLE WRAPPER ---
// This macro works for all boards because it just wraps whatever LAYOUT_36 produces
#define ZMK_LAYER(name, layout) \
    name { \
        bindings = <layout>; \
    };

/*                                      60 KEY MATRIX / LAYOUT MAPPING
                                        SOFLE

  ╭────────────────────────────┬────────────────────────────╮ ╭─────────────────────────────┬─────────────────────────────╮
  │  0   1   2   3   4   5     │      6   7   8   9  10  11 │ │ LN5 LN4 LN3 LN2 LN1 LN0     │     RN0 RN1 RN2 RN3 RN4 RN5 │
  │ 12  13  14  15  16  17     │     18  19  20  21  22  23 │ │ LT5 LT4 LT3 LT2 LT1 LT0     │     RT0 RT1 RT2 RT3 RT4 RT5 │
  │ 24  25  26  27  28  29     │     30  31  32  33  34  35 │ │ LM5 LM4 LM3 LM2 LM1 LM0     │     RM0 RM1 RM2 RM3 RM4 RM5 │
  │ 36  37  38  39  40  41  42 │ 43  44  45  46  47  48  49 │ │ LB5 LB4 LB3 LB2 LB1 LB0 LEC │ REC RB0 RB1 RB2 RB3 RB4 RB5 │
  ╰───────╮ 50  51  52  53  54 │ 55  56  57  58  59 ╭───────╯ ╰───────╮ LH4 LH3 LH2 LH1 LH0 │ RH0 RH1 RH2 RH3 RH4 ╭───────╯
          ╰────────────────────┴────────────────────╯                 ╰─────────────────────┴─────────────────────╯         */



/*                              34 KEY MATRIX / LAYOUT MAPPING
                                SWEEP

  ╭────────────────────┬────────────────────╮ ╭─────────────────────┬─────────────────────╮
  │  0   1   2   3   4 │  5   6   7   8   9 │ │ LT4 LT3 LT2 LT1 LT0 │ RT0 RT1 RT2 RT3 RT4 │
  │ 10  11  12  13  14 │ 15  16  17  18  19 │ │ LM4 LM3 LM2 LM1 LM0 │ RM0 RM1 RM2 RM3 RM4 │
  │ 20  21  22  23  24 │ 25  26  27  28  29 │ │ LB4 LB3 LB2 LB1 LB0 │ RB0 RB1 RB2 RB3 RB4 │
  ╰───────────╮ 30  31 │ 32  33 ╭───────────╯ ╰───────────╮ LH1 LH0 │ RH0 RH1 ╭───────────╯
              ╰────────┴────────╯                         ╰─────────┴─────────╯             */



/******************************************************************************************************/
/* /\* In your Sofle-specific logic *\/                                                               */
/* #define ZMK_LAYER(name, layout)                                                \                   */
/*     name {                                                                     \                   */
/*         bindings = <&none & none & none & none & none & none & none & none &   \                   */
/*                     none & none & none & none & none layout & none & none &    \                   */
/*                     none & none & none & none & none & none & none & none &    \                   */
/*                     none & none & none & none & none>;                         \                   */
/*     };                                                                                             */
/*                                                                                                    */
/*                                                                                                    */
/*                                                                                                    */
/* /\* In your Cradio-specific logic (no padding needed) *\/                                          */
/* #define ZMK_LAYER(name, layout) \                                                                  */
/*     name { \                                                                                       */
/*         bindings = <layout>; \                                                                     */
/*     };                                                                                             */
/*                                                                                                    */
/* / {                                                                                                */
/*     keymap {                                                                                       */
/*         compatible = "zmk,keymap";                                                                 */
/*                                                                                                    */
/*         ZMK_LAYER(default,                                                                         */
/*             LAYOUT_36_CORE(                                                                        */
/*                 &kp Q, &kp W, &kp E, &kp R, &kp T,    &kp Y, &kp U, &kp I, &kp O, &kp P,           */
/*                 &kp A, &kp S, &kp D, &kp F, &kp G,    &kp H, &kp J, &kp K, &kp L, &kp SEMI,        */
/*                 &kp Z, &kp X, &kp C, &kp V, &kp B,    &kp N, &kp M, &kp COMMA, &kp DOT, &kp SLASH, */
/*                               &kp LGUI, &mo 1, &kp SPC, &kp RET, &mo 2, &kp RALT                   */
/*             )                                                                                      */
/*         )                                                                                          */
/*     };                                                                                             */
/* };                                                                                                 */
/******************************************************************************************************/
