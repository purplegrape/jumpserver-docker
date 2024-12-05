#!/usr/bin/env bash

set -x

if [ ! -d /data/jumpserver ];then
    unzip -qn /opt/jumpserver.zip
    cd /data/jumpserver
    . /opt/py3/bin/activate
    rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
    django-admin compilemessages
fi

exec $@