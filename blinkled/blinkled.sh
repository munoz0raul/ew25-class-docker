#!/bin/bash

blink=1

while true; do
  echo "blink = $blink"
  if [ $blink -eq 1 ]; then
    trigger="default-on"
    blink=0
  else
    trigger="none"
    blink=1
  fi
  echo "$trigger" > /sys/class/leds/ledG/trigger
  echo "$trigger" > /sys/class/leds/ledB/trigger
  sleep 1 & wait
done
