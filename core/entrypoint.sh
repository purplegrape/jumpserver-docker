#!/usr/bin/env bash

set -e -x

if [ ! -d /data/jumpserver ] ;then
  /usr/bin/rsync -aq --delete /opt/jumpserver/ /data/jumpserver/
  cd /data/jumpserver
  rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
  python3.11 apps/manage.py compilemessages
fi

. /opt/py3/bin/activate

exec $@
