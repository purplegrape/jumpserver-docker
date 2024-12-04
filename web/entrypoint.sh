#!/usr/bin/env bash

set -e -x

if [ -d /data/nginx ] ;then
  /usr/bin/rsync -aq --delete /data/nginx/ /etc/nginx/
fi

if [ ! -d /data/webroot ] ;then
  /usr/bin/rsync -aq --delete /opt/webroot/ /data/webroot/
fi

mkdir -p /data/logs

exec $@
