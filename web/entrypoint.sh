#!/usr/bin/env bash

set -e -x

if [ -d /data/nginx ] ;then
  /usr/bin/rsync -aq --delete /data/nginx/ /etc/nginx/
fi

if [ ! -d /data/lina ] ;then
  /usr/bin/rsync -aq --delete /opt/lina/ /data/lina/
fi

if [ ! -d /data/luna ] ;then
  /usr/bin/rsync -aq --delete /opt/luna/ /data/luna/
fi

mkdir -p /data/logs

exec $@
