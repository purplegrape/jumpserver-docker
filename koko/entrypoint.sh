#!/usr/bin/env bash

set -x

if [ ! -d /data/koko ];then

cp -a /opt/koko /data/koko
mv /data/koko/config_example.yml /data/koko/config.yml

BOOTSTRAP_TOKEN=$(head -c10 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 48)
cat >/data/koko/config.yml <<EOF
CORE_HOST: http://127.0.0.1:8080
BOOTSTRAP_TOKEN: $BOOTSTRAP_TOKEN
EOF

fi

exec $@
