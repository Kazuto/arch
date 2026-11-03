#!/usr/bin/env bash
# Toggle fullscreen mode based on window class.
# Browsers get maximize mode (1), everything else gets true fullscreen (0).

BROWSER_CLASSES="google-chrome|vivaldi-stable|firefox|brave-browser"

active_class=$(hyprctl activewindow -j | python3 -c "import sys,json; print(json.load(sys.stdin).get('class',''))" 2>/dev/null)

if echo "$active_class" | grep -qiE "$BROWSER_CLASSES"; then
    hyprctl dispatch "hl.dsp.window.fullscreen({ mode = 'maximized' })"
else
    hyprctl dispatch "hl.dsp.window.fullscreen({ mode = 'fullscreen' })"
fi
