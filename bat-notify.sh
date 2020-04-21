#!/bin/bash
# Battery Notification Script
# Version 3.0

i=0
BatteryDischarging="Discharging"
BatteryCharging="Charging"
BatteryFull="Full"
CriticalAlert=10
NormalAlert=15
LowAlert=95

function Discharging () {
  i=0
  if [[ $BatteryCapacity -le $CriticalAlert ]]; then
    notify-send -u critical "Alert" "Battery Low!!!"
    sleep 30
  elif [[ $BatteryCapacity -le $NormalAlert ]]; then
    nofify-send -u normal "Alert" "Battery getting low..."
    sleep 60
  elif [[ $BatteryCapacity -le $LowAlert ]]; then
    notify-send -u low "Alert" "Think about plugging in computer if possible..."
    sleep 300
  fi
}

function Full () {
  if [[ "${i}" -eq 0 ]]; then
    notify-send -u normal "Alert" "Battery fully charged."
    ((i++))
  fi
}

function Charging () {
  if [[ "${i}" -ne 0 ]] && [[ $BatteryCapacity -le 80 ]]; then
    i=0
  fi
  sleep 2
}

while true; do

read -r BatteryCapacity < /sys/class/power_supply/BAT0/capacity
read -r BatteryStatus   < /sys/class/power_supply/BAT0/status

  case "${BatteryStatus}" in
    "${BatteryDischarging}") Discharging;;
           "${BatteryFull}") Full;;
       "${BatteryCharging}") Charging;;
                          *) i=1; sleep 2;;
  esac
done