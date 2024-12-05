#!/usr/bin/env bash

set -x

if [ ! -d /data/koko ];then

cp -a /opt/koko /data/koko
cat >/data/koko/config.yml <<EOF
CORE_HOST: http://127.0.0.1:8080
BOOTSTRAP_TOKEN: <PleaseChangeSameWithJumpserver>
EOF

fi

exec $@
