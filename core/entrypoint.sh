#!/usr/bin/env bash

set -x

if [ ! -d /data/jumpserver ];then
unzip -qn /opt/jumpserver.zip
cd /data/jumpserver
. /opt/py3/bin/activate
rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
django-admin compilemessages

SECRET_KEY=$(head -c100 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 48)
BOOTSTRAP_TOKEN=$(head -c10 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 48)

cat > /data/jumpserver/config.yml <<EOF
SECRET_KEY: $SECRET_KEY
BOOTSTRAP_TOKEN: $BOOTSTRAP_TOKEN
DB_ENGINE: mysql
DB_HOST: 127.0.0.1
DB_PORT: 3306
DB_USER: root
DB_PASSWORD:
DB_NAME: jumpserver


HTTP_BIND_HOST: 0.0.0.0
HTTP_LISTEN_PORT: 8080
WS_LISTEN_PORT: 8070
REDIS_HOST: 127.0.0.1
REDIS_PORT: 6379
EOF

fi
exec $@