#!/usr/bin/env bash

set -x

if [ ! -d /data/koko ];then
    cp -a /opt/koko /data/koko
    mv /data/koko/config_example.yml /data/koko/config.yml
fi

if [ $# == '0' ];then
    cd /data/koko
    exec /data/koko/koko
fi

exec $@