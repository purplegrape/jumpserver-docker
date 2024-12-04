#!/usr/bin/env bash

set -e -x

if [ ! -d /data/koko ] ;then
  /usr/bin/rsync -aqu /opt/koko/ /data/koko/
fi

exec $@
