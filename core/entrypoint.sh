#!/usr/bin/env bash

set -e -x

if [ ! -d /data/jumpserver ] ;then
  /usr/bin/rsync -aqu /opt/jumpserver/ /data/jumpserver/
fi

. /opt/py3/bin/active

exec $@
