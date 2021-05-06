#!/bin/bash
#
#

s=53 #sleep
m=$(date -d "+1 minute" "+%M")

if [[ "$m" -eq 0 ]]; then
  h=$(date -d "+1 hour" "+%I")
fi
if [[ "$m" -eq 30 ]]; then
  h="01"
fi

F="$HOME/sounds/PendulumClock/PC$h.mp3"
if [[ -n $h || -f "$F" ]]; then
  echo "Pendeluhr: sleep ${s}s"
  sleep $s
  echo "strike $h" | systemd-cat -t pendeluhr
  echo "Pendeluhr: $h"
  /usr/bin/amixer -q sset Speaker 90%
  /usr/bin/mpg123 -q "$F"
  /usr/bin/amixer -q sset Speaker 90%
fi

exit 0
