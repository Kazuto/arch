#!/bin/bash
#
# Smart wallpaper script for swww
# Auto-detects if image should be split based on resolution:
# - Wide images (≥5000px width): split across monitors
# - Normal images: repeat on all monitors
#

IMAGE="$1"
TEMP_DIR="/tmp/swww-split"

if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image-file>"
    exit 1
fi

# Get image format extension
IMG_EXT="${IMAGE##*.}"

# Get monitor info sorted by X position (left to right)
MONITORS=($(hyprctl monitors -j | jq -r 'sort_by(.x) | .[].name'))
MON1="${MONITORS[0]}" # HDMI-A-1 (1440x2560) - Left (rotated 90deg)
MON2="${MONITORS[1]}" # DP-1 (3440x1440) - Center
MON3="${MONITORS[2]}" # DP-2 (1440x2560) - Right (rotated -90deg)

# Total monitor width = 1440 + 3440 + 1440 = 6320 (after rotation)
TOTAL_WIDTH=6320
THRESHOLD=$((TOTAL_WIDTH - 500)) # Trigger if image ≥ 5100px wide

# Get image dimensions
IMG_WIDTH=$(identify -format "%w" "$IMAGE")
IMG_HEIGHT=$(identify -format "%h" "$IMAGE")

echo "Image: ${IMG_WIDTH}x${IMG_HEIGHT}"

# Auto-detect: split if image is wide enough for triple monitors
if [ "$IMG_WIDTH" -ge "$THRESHOLD" ]; then
    echo "Wide image detected! Splitting across monitors..."

    mkdir -p "$TEMP_DIR"

    # Calculate split points based on monitor ratios (after rotation)
    # Left monitor (DP-3): 1440px = 22.8% of total (rotated portrait)
    # Center monitor (DP-1): 3440px = 54.4% of total (landscape)
    # Right monitor (DP-2): 1440px = 22.8% of total (rotated portrait)
    SPLIT1_X=$((IMG_WIDTH * 1440 / TOTAL_WIDTH))
    SPLIT2_X=$((IMG_WIDTH * 4880 / TOTAL_WIDTH))

    # Split image into 3 parts (no rotation - Hyprland's transform handles it)
    magick convert "$IMAGE" -crop "${SPLIT1_X}x${IMG_HEIGHT}+0+0" +repage "$TEMP_DIR/left.${IMG_EXT}"
    magick convert "$IMAGE" -crop "$((SPLIT2_X - SPLIT1_X))x${IMG_HEIGHT}+${SPLIT1_X}+0" +repage "$TEMP_DIR/center.${IMG_EXT}"
    magick convert "$IMAGE" -crop "$((IMG_WIDTH - SPLIT2_X))x${IMG_HEIGHT}+${SPLIT2_X}+0" +repage "$TEMP_DIR/right.${IMG_EXT}"

    # Apply to monitors with transition
    awww img "$TEMP_DIR/left.${IMG_EXT}" --outputs "$MON1" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right &
    awww img "$TEMP_DIR/center.${IMG_EXT}" --outputs "$MON2" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right &
    awww img "$TEMP_DIR/right.${IMG_EXT}" --outputs "$MON3" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right &
    wait

    notify-send "Wallpaper Split" "Applied across all three monitors\n${IMG_WIDTH}x${IMG_HEIGHT}"
else
    # Normal mode: repeat on all monitors with transition
    awww img "$IMAGE" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right
    notify-send "Wallpaper" "Applied to all monitors\n${IMG_WIDTH}x${IMG_HEIGHT}"
fi
