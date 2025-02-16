#!/bin/bash

# File paths for LED states
LED_GREEN_FILE="/home/ledG"
LED_BLUE_FILE="/home/ledB"

# LED control paths
LED_GREEN_TRIGGER="/sys/class/leds/ledG/trigger"
LED_BLUE_TRIGGER="/sys/class/leds/ledB/trigger"

# Infinite loop with 1-second delay
while true; do
    # Read the value for LED Green
    LED_GREEN=$(cat "$LED_GREEN_FILE" 2>/dev/null)
    if [[ "$LED_GREEN" == "1" ]]; then
        echo "Turning on LED Green"
        echo "default-on" > "$LED_GREEN_TRIGGER"
    elif [[ "$LED_GREEN" == "0" ]]; then
        echo "Turning off LED Green"
        echo "none" > "$LED_GREEN_TRIGGER"
    else
        echo "LED Green file contains an invalid value"
    fi

    # Read the value for LED Blue
    LED_BLUE=$(cat "$LED_BLUE_FILE" 2>/dev/null)
    if [[ "$LED_BLUE" == "1" ]]; then
        echo "Turning on LED Blue"
        echo "default-on" > "$LED_BLUE_TRIGGER"
    elif [[ "$LED_BLUE" == "0" ]]; then
        echo "Turning off LED Blue"
        echo "none" > "$LED_BLUE_TRIGGER"
    else
        echo "LED Blue file contains an invalid value"
    fi

    # Wait for 1 second before the next iteration
    sleep 1
done
