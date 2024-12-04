#!/usr/bin/env bash

set -e -x

if [ -d /data/nginx ] ;then
  /usr/bin/rsync -aq --delete /data/nginx/ /etc/nginx/
fi

mkdir -p /data/logs

exec $@
