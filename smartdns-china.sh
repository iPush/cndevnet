#!/bin/bash -
set -e

WORKDIR="${PWD}"
TMPDIR="$(mktemp -d)"

echo "Downloading latest configurations..."
git clone --depth=1 https://gitee.com/felixonmars/dnsmasq-china-list.git "$TMPDIR"


echo "Removing old configurations..."
rm -f "${WORKDIR}/smartdns/*.china.smartdns.conf" | true

echo "Installing new configurations..."
cd "$TMPDIR" && make smartdns
mv *.china.smartdns.conf "${WORKDIR}/smartdns"

echo "Cleaning up..."
rm -r "$TMPDIR"
