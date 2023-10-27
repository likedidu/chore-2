#!/bin/sh

exec 2>&1

if [ "${VmessUUID}" = "" ]; then
    VmessUUID=ad2c9acd-3afb-4fae-aff2-954c532020bd
fi

cp -f /app/config-wg.json /tmp/config.json
sed -i "s|ad2c9acd-3afb-4fae-aff2-954c532020bd|${VmessUUID}|g;s|PASSWORD|${PASSWORD}|g;s|SecretPATH|${SecretPATH}|g;s|1408|${WG_MTU}|" /tmp/config.json

jq '.experimental.clash_api.default_mode |= "'"${CLASH_MODE}"'"' /tmp/config.json >./config.json
mv ./config.json /tmp/config.json

if [ "${OVERRIDE_DEST}" = "disable" ]; then
    sed -i "s|\"sniff_override_destination\": true|\"sniff_override_destination\": false|g" /tmp/config.json
fi

if [ ! "${BLOCK_QUIC_443}" = "true" ]; then
    jq 'del(.route.rules[1])' /tmp/config.json >./config.json
    mv ./config.json /tmp/config.json
fi

cd /usr/bin

exec ./app* run -c /tmp/config.json

exec caddy run --config /app/Caddyfile --adapter caddyfile

DIR_CONFIG="/app"

# Config & Run argo tunnel
if [ "${ArgoJSON}" = "" ]; then
    exec sleep infinity
else
    echo $ArgoJSON >${DIR_CONFIG}/argo.json
    ARGOID="$(jq .TunnelID ${DIR_CONFIG}/argo.json | sed 's/\"//g')"
    sed -i "s|ARGOID|${ARGOID}|g;s|PORT|${PORT}|" ${DIR_CONFIG}/argo.yaml
    exec argo --loglevel info tunnel -config ${DIR_CONFIG}/argo.yaml run ${ARGOID}
fi