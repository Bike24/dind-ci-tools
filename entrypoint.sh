#!/usr/bin/env bash

set -e

COMMAND="${1}"
KEYSERVER1="hkp://ipv4.pool.sks-keyservers.net"
KEYSERVER2="hkp://keys.gnupg.net"
KEYSERVER3="hkp://keyserver.ubuntu.com:80"

if [ -n "${GPG_PUB_KEYS}" ]; then
  for KEY in ${GPG_PUB_KEYS}; do
    echo "Fetch ${KEY} from ${KEYSERVER1}"
    if ! gpg --keyserver ${KEYSERVER1} --recv "${KEY}"; then
      echo "Fallback: Fetch ${KEY} from ${KEYSERVER2}"
      if ! gpg --keyserver ${KEYSERVER2} --recv "${KEY}"; then
        echo "2nd fallback: Fetch ${KEY} from ${KEYSERVER3}"
        gpg --keyserver ${KEYSERVER3} --recv "${KEY}"
      fi
    fi
  done
fi

if [ -n "${COMMAND}" ]; then
  "${COMMAND}"
else
  bash /data/commands.sh
fi
