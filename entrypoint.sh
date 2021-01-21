#!/usr/bin/env bash

set -e

COMMAND="${1}"
KEYSERVER1="hkp://ipv4.pool.sks-keyservers.net"
KEYSERVER2="hkp://keys.gnupg.net"
KEYSERVER3="hkp://pgp.mit.edu:80"
KEYSERVER4="hkp://keyserver.ubuntu.com:80"

if [ -n "${GPG_PUB_KEYS}" ]; then
  for KEY in ${GPG_PUB_KEYS}; do
    gpg --batch --keyserver ${KEYSERVER1} --recv-keys "${KEY}" || \
    gpg --batch --keyserver ${KEYSERVER2} --recv-keys "${KEY}" || \
    gpg --batch --keyserver ${KEYSERVER3} --recv-keys "${KEY}" || \
    gpg --batch --keyserver ${KEYSERVER4} --recv-keys "${KEY}" 
  done
fi

if [ -n "${COMMAND}" ]; then
  "${COMMAND}"
else
  bash /data/commands.sh
fi
