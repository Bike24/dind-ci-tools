#!/usr/bin/env bash

set -e

COMMAND="${1}"

if [ -n "${GPG_PUB_KEYS}" ]; then

  for KEY in ${GPG_PUB_KEYS}; do

    echo "Fetch ${KEY} from hkp://p80.pool.sks-keyservers.net:80"

    if ! gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv "${KEY}"; then
      echo "Fallback: Fetch ${KEY} from hkp://ipv4.pool.sks-keyservers.net"
    elif ! gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv "${KEY}"; then
        echo "2nd fallback: Fetch ${KEY} from hkp://pgp.mit.edu:80"
    else 
      gpg --keyserver hkp://pgp.mit.edu:80 --recv "${KEY}"
    fi
  done
fi

if [ -n "${COMMAND}" ]; then
  "${COMMAND}"
else
  sh /data/commands.sh
fi
