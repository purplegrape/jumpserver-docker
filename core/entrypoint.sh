#!/usr/bin/env bash

set -x

if [ ! -d /opt/py3 ];then
    cd /opt
    unzip -qn /opt/py3.zip
fi

if [ ! -d /data/jumpserver ];then
    unzip -qn /opt/jumpserver.zip
    cd /data/jumpserver
    . /opt/py3/bin/activate
    rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
    django-admin compilemessages
    chown -R nobody:nobody /data/jumpserver
fi

exec $@