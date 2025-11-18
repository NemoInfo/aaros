#!/usr/bin/env bash

set -euo pipefail

FLAKE="/home/aaron/aaros#nvidia-amd"
LOGFILE=$(mktemp)
NOTIFY_ID=$(notify-send --transient -p "󱄅 NixOS Rebuild" "Start" 2>&1)
SPINNER=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
SPIN_INDEX=0

set +e
pkexec nixos-rebuild switch --flake "$FLAKE" 2>&1 | tee "$LOGFILE" | \
while IFS= read -r line; do
    short=$(echo "$line" | sed 's/\(.\{50\}\).*/\1…/')
    FRAME="${SPINNER[$SPIN_INDEX]}"
    SPIN_INDEX=$(( (SPIN_INDEX + 1) % ${#SPINNER[@]} ))
    notify-send --transient --replace-id "$NOTIFY_ID" "󱄅 NixOS Rebuild $FRAME" "$short"
done
STATUS=${PIPESTATUS[0]}
set -e

if [ $STATUS -eq 0 ]; then
    notify-send -t 1000 --transient --replace-id "$NOTIFY_ID" "󱄅 NixOS Rebuild" "✔ Complete!"
else
    notify-send --transient --replace-id "$NOTIFY_ID" "󱄅 NixOS Rebuild" "✖ Error! Opening log…"
    ghostty --class "log-popup" -e nvim "$LOGFILE" +$
fi
