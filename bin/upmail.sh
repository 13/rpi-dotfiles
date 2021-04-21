#!/bin/bash

MAILER="$HOME/bin/msmtp-enqueue.sh"
LOCKFILE="$HOME/.msmtpqueue/.lock"

TIME="$(date +"%H:%M:%S")"

if [ -f $LOCKFILE ]; then
  rm $LOCKFILE
fi
echo -e "Subject: $(hostname) ON $TIME\n\n" | $MAILER $1 &
sleep 1
$HOME/bin/msmtp-runqueue.sh &
exit 0
