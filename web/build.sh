#!/usr/bin/env bash

TS=$(date +%Y%m%d)
basedir=`dirname $0`

cd $basedir
podman build -t jumpserver/web:$TS .

exit 0
