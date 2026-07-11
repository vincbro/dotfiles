// GENERATED FROM KGEN 

#include QMK_KEYBOARD_H

enum layers {
    BASE,
    NAV,
    SYM
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [BASE] = LAYOUT_elora_hlc(
     KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
     KC_NO, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_NO,
     KC_NO, KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_SCLN, KC_NO,
     KC_NO, MT(MOD_LGUI,KC_Z), MT(MOD_LALT,KC_X), KC_C, KC_V, KC_B, KC_NO, KC_NO, KC_NO, KC_NO, KC_N, KC_M, MT(MOD_RGUI,KC_COMM), MT(MOD_RALT,KC_DOT), MT(MOD_RCTL,KC_SLSH), KC_NO,
     KC_NO, KC_NO, LT(NAV,KC_TAB), MT(MOD_LSFT,KC_SPC), KC_NO, KC_NO, KC_ENT, LT(SYM,KC_BSPC), KC_NO, KC_NO,
     KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO, KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO
    ),
    [NAV] = LAYOUT_elora_hlc(
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     _______, _______, _______, _______, _______, _______, KC_HOME, KC_PGDN, KC_PGUP, KC_END, _______, _______,
     _______, _______, _______, _______, KC_ESC, KC_LCTL, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, _______, _______,
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO, KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO
    ),
    [SYM] = LAYOUT_elora_hlc(
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     _______, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0, _______,
     _______, _______, KC_GRV, KC_MINS, KC_EQL, KC_QUOT, KC_LPRN, KC_RPRN, KC_LCBR, KC_RCBR, _______, _______,
     _______, _______, _______, _______, _______, KC_BSLS, _______, _______, _______, _______, KC_LBRC, KC_RBRC, S(KC_COMM), S(KC_DOT), _______, _______,
     _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
     KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO, KC_MUTE, KC_NO, KC_NO, KC_NO, KC_NO
    )
};

const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT_elora_hlc(
     'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R',
     'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R'
);

#if defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {
    [BASE] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
    [NAV] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
    [SYM] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
};
#endif

