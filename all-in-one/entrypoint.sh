#!/usr/bin/env bash

set -e -x

SECRET_KEY=$(head -c100 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 48)
BOOTSTRAP_TOKEN=$(head -c10 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 48)

if [ -d /data/nginx ] ;then
    /usr/bin/rsync -aq --delete /data/nginx/ /etc/nginx/
    mkdir -p /data/wwwlogs
fi

if [ -d /data/redis ] ;then
    mkdir -p /data/redis
    chown -R redis:redis /data/redis
fi

if [ -d /data/guacd ] ;then
    mkdir -p /data/guacd
    chown -R guacd:guacd /data/guacd
fi

if [ ! -d /data/jumpserver ] ;then
    /usr/bin/rsync -aq --delete /opt/jumpserver/ /data/jumpserver/
    . /opt/py3/bin/activate
    cd /data/jumpserver
    rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
    django-admin compilemessages
    chown -R nobody:nobody data tmp
    cat > /data/jumpserver/config.yml <<EOF
SECRET_KEY: $SECRET_KEY
BOOTSTRAP_TOKEN: $BOOTSTRAP_TOKEN
DB_ENGINE: mysql
DB_HOST: mysql
DB_PORT: 3306
DB_USER: jumpserver
DB_PASSWORD:
DB_NAME: jumpserver

HTTP_BIND_HOST: 127.0.0.1
HTTP_LISTEN_PORT: 8080
WS_LISTEN_PORT: 8070
REDIS_HOST: 127.0.0.1
REDIS_PORT: 6379
EOF
fi

if [ ! -d /data/koko ];then
    rsync -aq --delete /opt/koko/ /data/koko/
    cat > /data/koko/config.yml <<EOF
CORE_HOST: http://127.0.0.1:8080
BOOTSTRAP_TOKEN: $BOOTSTRAP_TOKEN
EOF
    mkdir -p /data/koko/data
    chown -R nobody:nobody /data/koko/data
fi

if [ ! -d /data/lion ];then
    rsync -aq --delete /opt/lion/ /data/lion/
    cat > /data/lion/config.yml <<EOF
CORE_HOST: http://127.0.0.1:8080
BOOTSTRAP_TOKEN: $BOOTSTRAP_TOKEN
EOF
    chown -R nobody:nobody /data/lion
fi

exec $@
