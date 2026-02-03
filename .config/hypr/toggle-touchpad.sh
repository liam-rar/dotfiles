#!/usr/bin/env bash

# Get all touchpad devices
TOUCHPADS=$(hyprctl -j devices | jq -r '.mice[].name | select(contains("touchpad"))')

# State file to track touchpad status
STATE_FILE="/tmp/touchpad_state"

# Read current state or default to enabled
if [ -f "$STATE_FILE" ]; then
    CURRENT_STATE=$(cat "$STATE_FILE")
else
    CURRENT_STATE="enabled"
fi

if [ "$CURRENT_STATE" = "enabled" ]; then
    # Disable all touchpad devices
    for device in $TOUCHPADS; do
        hyprctl keyword "device[$device]:enabled" false
    done
    echo "disabled" > "$STATE_FILE"
    notify-send "Touchpad" "Disabled" -i input-touchpad
else
    # Enable all touchpad devices
    for device in $TOUCHPADS; do
        hyprctl keyword "device[$device]:enabled" true
    done
    echo "enabled" > "$STATE_FILE"
    notify-send "Touchpad" "Enabled" -i input-touchpad
fi
