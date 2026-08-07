#!/usr/bin/env bash

# Parse command line arguments
NOOP=false
for arg in "$@"; do
    if [ "$arg" = "--noop" ]; then
        NOOP=true
    fi
done

SELECTED_KB=$(find kgen -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sk --prompt="Select keyboard> ")

USERSPACE_ROOT="$HOME/Documents/projects/qmk_userspace"
KGEN_ROOT="kgen/$SELECTED_KB"
KGEN_OUTPUT="$KGEN_ROOT/output.c"

case "$SELECTED_KB" in
    elora)
        KEYMAP_DIR="$USERSPACE_ROOT/keyboards/splitkb/halcyon/elora/keymaps/default_hlc"
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
        ;;
    ferris)
        KEYMAP_DIR="$USERSPACE_ROOT/keyboards/ferris/sweep/keymaps/vince"
        KB="ferris/sweep"
        KM="vince"
        ADDON=""
        ;;
    *)
        echo "Unsupported keyboard: $SELECTED_KB" >&2
        exit 1
        ;;
esac

KEYMAP_FILE="$KEYMAP_DIR/keymap.c"
CONFIG_FILE="$KEYMAP_DIR/config.h"

kgen format -p "$KGEN_ROOT"
kgen build -p "$KGEN_ROOT" -m qmk -o "$KGEN_OUTPUT"

if [ -n "$ADDON" ]; then
    echo "$ADDON" >> "$KGEN_OUTPUT"
fi

mkdir -p "$KEYMAP_DIR"
cp "$KGEN_OUTPUT" "$KEYMAP_FILE"
cp "$KGEN_ROOT/config.h" "$CONFIG_FILE"

case "$SELECTED_KB" in
    elora)
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
        ;;
    ferris)
        if [ "$NOOP" = true ]; then
            echo "NOOP mode: compiling keymap without flashing..."
            qmk compile -kb "$KB" -km "$KM" -e CONVERT_TO=rp2040_ce
            echo "Compilation successful!"
        else
            echo "Flashing Ferris Sweep..."
            qmk flash -kb "$KB" -km "$KM" -e CONVERT_TO=rp2040_ce
            echo "Done with Ferris Sweep :)"
        fi
        ;;
esac
