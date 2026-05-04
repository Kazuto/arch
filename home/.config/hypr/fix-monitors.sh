#!/bin/bash
# Fix monitor assignments after input switching

# Force move workspaces to correct monitors
# DP-1 (Middle ultrawide): Workspaces 1-10
for i in {1..10}; do
    hyprctl dispatch moveworkspacetomonitor "$i" "desc:GIGA-BYTE TECHNOLOGY CO. LTD. G34WQC A 24142B000602"
done

# DP-2 (Right vertical): Workspaces 11-20
for i in {11..20}; do
    hyprctl dispatch moveworkspacetomonitor "$i" "desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25355B006220"
done

# DP-3 (Left vertical): Workspaces 21-30
for i in {21..30}; do
    hyprctl dispatch moveworkspacetomonitor "$i" "desc:GIGA-BYTE TECHNOLOGY CO. LTD. GS27QCA 25465B003652"
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
