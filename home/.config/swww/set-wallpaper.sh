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

# Get monitor info
MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))
MON1="${MONITORS[0]}"  # Primary (DP-1: 3440x1440)
MON2="${MONITORS[1]}"  # Secondary (DP-2: 1920x1080)

# Total monitor width = 3440 + 1920 = 5360
TOTAL_WIDTH=5360
THRESHOLD=$((TOTAL_WIDTH - 500))  # Trigger if image ≥ 4860px wide

# Get image dimensions
IMG_WIDTH=$(identify -format "%w" "$IMAGE")
IMG_HEIGHT=$(identify -format "%h" "$IMAGE")

echo "Image: ${IMG_WIDTH}x${IMG_HEIGHT}"

# Auto-detect: split if image is wide enough for dual monitors
if [ "$IMG_WIDTH" -ge "$THRESHOLD" ]; then
    echo "Wide image detected! Splitting across monitors..."

    mkdir -p "$TEMP_DIR"

    # Calculate split point based on monitor ratio
    # 3440/(3440+1920) = 64%
    SPLIT_X=$((IMG_WIDTH * 3440 / TOTAL_WIDTH))

    # Split image (preserve format)
    convert "$IMAGE" -crop "${SPLIT_X}x${IMG_HEIGHT}+0+0" +repage "$TEMP_DIR/left.${IMG_EXT}"
    convert "$IMAGE" -crop "$((IMG_WIDTH-SPLIT_X))x${IMG_HEIGHT}+${SPLIT_X}+0" +repage "$TEMP_DIR/right.${IMG_EXT}"

    # Apply to monitors with transition
    swww img "$TEMP_DIR/left.${IMG_EXT}" --outputs "$MON1" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right &
    swww img "$TEMP_DIR/right.${IMG_EXT}" --outputs "$MON2" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right &
    wait

    notify-send "Wallpaper Split" "Applied across both monitors\n${IMG_WIDTH}x${IMG_HEIGHT}"
else
    # Normal mode: repeat on all monitors with transition
    swww img "$IMAGE" --resize crop \
        --transition-type grow --transition-duration 0.5 --transition-fps 60 --transition-pos top-right
    notify-send "Wallpaper" "Applied to all monitors\n${IMG_WIDTH}x${IMG_HEIGHT}"
fi
