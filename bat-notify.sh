#!/bin/bash
# Battery Notification Script
# Version 3.0

i=0

while true
do

BatteryCapacity=$(cat /sys/class/power_supply/BAT0/capacity)
BatteryStatus=$(cat /sys/class/power_supply/BAT0/status)
BatteryDischarging="Discharging"
BatteryCharging="Charging"
BatteryFull="Full"
CriticalAlert=10
NormalAlert=15
LowAlert=95

  if [[ "$BatteryStatus" == "$BatteryDischarging" ]]; then
    if [[ $BatteryCapacity -le $CriticalAlert ]]; then
      ((i=0))
      notify-send -u critical "Alert" "Battery Low!!!"
      sleep 30
    elif [[ $BatteryCapacity -le $NormalAlert ]]; then
      ((i=0))
      nofify-send -u normal "Alert" "Battery getting low..."
      sleep 60
    elif [[ $BatteryCapacity -le $LowAlert ]]; then
      ((i=0))
      notify-send -u low "Alert" "Think about plugging in computer if possible..."
      sleep 300
    fi
  elif [[ "$BatteryStatus" == "$BatteryFull" ]]; then
    if [[ "${i}" -eq 0 ]]; then
      notify-send -u normal "Alert" "Battery fully charged."
      ((i++))
    fi
  elif [[ "$BatteryStatus" == "$BatteryCharging" ]]; then
    if [[ "${i}" -eq 0 ]]; then
      sleep 2
    fi
  elif [[ "$BatteryStatus" == "$BatteryCharging" ]]; then
    if [[ $BatteryCapacity -le 80 ]]; then
      ((i=0))
    sleep 2
    fi
  else
    ((i=1))
    sleep 2
  fi
done