#!/bin/bash
# Fix monitor assignments after input switching

# Force move workspaces to correct monitors
# HDMI-A-1 (Middle ultrawide): Workspaces 1-5
for i in {1..5}; do
    hyprctl dispatch "hl.dsp.workspace.move({ workspace = '$i', monitor = 'desc:GIGA-BYTE TECHNOLOGY CO. LTD. G34WQC A' })"
done

# DP-2 (Right vertical): Workspaces 6-7
for i in {6..7}; do
    hyprctl dispatch "hl.dsp.workspace.move({ workspace = '$i', monitor = 'desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25355B006220' })"
done

# DP-1 (Left vertical): Workspaces 8-9
for i in {8..9}; do
    hyprctl dispatch "hl.dsp.workspace.move({ workspace = '$i', monitor = 'desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25465B003652' })"
done

# Kill quickshell completely
pkill -9 quickshell
sleep 1

# Wait for monitor assignments to settle
sleep 1

# Restart quickshell to fix bar positioning
quickshell &
sleep 1

echo "Monitor layout fixed!"
