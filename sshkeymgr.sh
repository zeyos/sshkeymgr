#!/bin/bash

# Generates the authorized_keys file base on the ZeyOS permissions
#
# Usage:
#
#   sshkeymgr.sh <PLATFORMID> <SERVERNAME>
#
# Add this to your cron.daily
#
# Copyright: ZeyOS, Inc. 2016
# Author: Peter-Christoph Haider <peter.haider@zeyos.com>
# License: MIT

PLATFORM="$1"
SERVER="$2"

USAGE=$'\n\nUsage:\n  sshkeymgr.sh <PLATFORMID> <SERVERNAME>\n'

if [[ -z "$PLATFORM" ]]; then
  echo "No platform defined!${USAGE}"
  exit 1
fi

if [[ $PLATFORM =~ ^http.* ]]; then
  URL="${PLATFORM}"
else
  if [[ -z "$SERVER" ]]; then
    echo "No server defined!${USAGE}"
    exit 1
  fi
  URL="https://cloud.zeyos.com/${PLATFORM}/remotecall/sshkeys/${SERVER}"
fi

AUTHKEYS=$(curl -f -s -S -k ${URL})

if ! [[ "$AUTHKEYS" =~ ^ssh-rsa.* ]]; then
	echo "Invalid result: ${AUTHKEYS}"
    exit 1
fi

# Update the key file
echo "${AUTHKEYS}" > /root/.ssh/authorized_keys
echo "Public keys written"

exit 0
