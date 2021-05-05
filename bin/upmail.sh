#!/bin/bash

MAIL=""

MAILER="$HOME/bin/msmtp-enqueue.sh"
LOCKFILE="$HOME/.msmtpqueue/.lock"

TIME="$(date +"%H:%M:%S")"

if [ -f $LOCKFILE ]; then
  rm $LOCKFILE
fi
[ ! -z "$1" ] && MAIL="$1"
echo -e "Subject: $(hostname) ON $TIME\n\n" | $MAILER $MAIL &
sleep 1
$HOME/bin/msmtp-runqueue.sh &
exit 0
