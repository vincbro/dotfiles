#!/usr/bin/env bash

# Parse command line arguments
NOOP=false
for arg in "$@"; do
    if [ "$arg" = "--noop" ]; then
        NOOP=true
    fi
done

KB=$(ls kgen | sk --prompt="Select keyboard> ")

USERSPACE_ROOT="$HOME/Documents/projects/qmk_userspace"
KGEN_ROOT="kgen/$KB"
KGEN_OUTPUT="$KGEN_ROOT/output.c"
KEYMAP_FILE="$HOME/Documents/projects/qmk_userspace/keyboards/splitkb/halcyon/elora/keymaps/default_hlc/keymap.c"
KB="splitkb/halcyon/elora/rev2"
KM="default_hlc"

ADDON="
#if defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {
    [BASE] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
    [NAV] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
    [SYM] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU),  ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
};
#endif
"

kgen format -p "$KGEN_ROOT"
kgen build -p "$KGEN_ROOT" -m qmk -o "$KGEN_OUTPUT"

echo "$ADDON" >> "$KGEN_OUTPUT"

cp "$KGEN_OUTPUT" "$KEYMAP_FILE"

if [ "$NOOP" = true ]; then
    echo "NOOP mode: compiling keymap without flashing..."
    qmk compile -kb "$KB" -km "$KM" -e HLC_TFT_DISPLAY=1
    qmk compile -kb "$KB" -km "$KM" -e HLC_ENCODER=1
    echo "Compilation successful!"
else
    echo "Flashing LEFT side with Display module..."
    qmk flash -kb "$KB" -km "$KM" -e HLC_TFT_DISPLAY=1
    echo "Done with Left :)"
    echo "Flashing RIGHT side with Encoder module..."
    qmk flash -kb "$KB" -km "$KM" -e HLC_ENCODER=1
    echo "Done with Right :)"
fi
