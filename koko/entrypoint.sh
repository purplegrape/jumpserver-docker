#!/usr/bin/env bash

set -x

if [ ! -d /data/koko ];then

cp -a /opt/koko /data/koko
cat >/data/koko/config.yml <<EOF
CORE_HOST: http://127.0.0.1:8080
BOOTSTRAP_TOKEN: <PleasgeChangeSameWithJumpserver>
SHARE_ROOM_TYPE: redis
REDIS_HOST: 127.0.0.1
REDIS_PORT: 6379
EOF

fi

exec $@
