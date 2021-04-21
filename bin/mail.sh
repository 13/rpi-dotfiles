#!/bin/bash
#
#

MAILER="$HOME/bin/msmtp-enqueue.sh"
MAILER_ENQUEUE="$HOME/bin/msmtp-runqueue.sh"
LOCKFILE="$HOME/.msmtpqueue/.lock"

CLEAR='\033[0m'
RED='\033[0;31m'

TIME="$(date +"%H:%M:%S")"

function sendMail() {
  if [ -f $LOCKFILE ]; then
    rm $LOCKFILE
  fi

  echo -e "Subject: $SUBJECT\n\n$BODY" | $MAILER $ADDRESS &
  sleep 1
  $MAILER_ENQUEUE &
  exit 0
}

function usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}$1${CLEAR}\n";
  fi
  echo "Usage: $0 [-s subject] [-b body] [-a address]"
  echo "  -a, --subject             Subject"
  echo "  -b, --body                Body message"
  echo "  -s, --subject             Recipient address"
  echo ""
  echo "Example: $0 --subject \"hello you\" --body \"some text.\" --address x@y.z"
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -s|--subject) SUBJECT="$2";shift;shift;;
  -b|--body) BODY="$2";shift;shift;;
  -a|--address) ADDRESS="$2";shift;shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

# verify params
if [ -z "$SUBJECT" ]; then usage "Subject is not set"; fi;
if [ -z "$BODY" ]; then usage "Body message is not set."; fi;
if [ -z "$ADDRESS" ]; then usage "Recipient address is not set."; fi;

sendMail

