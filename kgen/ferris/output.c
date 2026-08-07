// GENERATED FROM KGEN 

#include QMK_KEYBOARD_H

enum layers {
    BASE,
    NAV,
    SYM
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [BASE] = LAYOUT_split_3x5_2(
     KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P,
     KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_SCLN,
     MT(MOD_LGUI,KC_Z), MT(MOD_LALT,KC_X), KC_C, KC_V, KC_B, KC_N, KC_M, MT(MOD_RGUI,KC_COMM), MT(MOD_RALT,KC_DOT), MT(MOD_RCTL,KC_SLSH),
     LT(NAV,KC_TAB), MT(MOD_LSFT,KC_SPC), KC_ENT, LT(SYM,KC_BSPC)
    ),
    [NAV] = LAYOUT_split_3x5_2(
     _______, _______, _______, _______, _______, KC_HOME, KC_PGDN, KC_PGUP, KC_END, _______,
     _______, _______, _______, KC_ESC, KC_LCTL, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, _______,
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     _______, _______, _______, _______
    ),
    [SYM] = LAYOUT_split_3x5_2(
     KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0,
     _______, KC_GRV, KC_MINS, KC_EQL, KC_QUOT, KC_LPRN, KC_RPRN, KC_LCBR, KC_RCBR, _______,
     _______, _______, _______, _______, KC_BSLS, KC_LBRC, KC_RBRC, S(KC_COMM), S(KC_DOT), _______,
     _______, _______, _______, _______
    )
};

const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT_split_3x5_2(
     'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R',
     '*', '*', '*', '*'
);
