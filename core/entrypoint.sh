#!/usr/bin/env bash

set -x

if [ ! -d /data/jumpserver ];then
  /usr/bin/rsync -aq --delete /opt/jumpserver/ /data/jumpserver/
  cd /data/jumpserver
  . /opt/py3/bin/activate
  rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
  django-admin compilemessages
  chown -R nobody:nobody /data/jumpserver
fi

exec $@