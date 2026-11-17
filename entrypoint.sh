#!/bin/sh
set -eu

XRAY_UUID=${XRAY_UUID:-}
if [ "${#XRAY_UUID}" -ne 36 ] ||
   ! printf '%s\n' "$XRAY_UUID" | grep -Eq '^[0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$'; then
    echo 'XRAY_UUID must be a UUID in 8-4-4-4-12 format.' >&2
    exit 1
fi

config=$(sed "s/__XRAY_UUID__/$XRAY_UUID/" /usr/local/etc/xray/config.json)
unset XRAY_UUID
exec /usr/local/bin/xray run -format json -c stdin: <<EOF
$config
EOF
