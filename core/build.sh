#!/usr/bin/env bash

TS=$(date +%Y%m%d)
basedir=`dirname $0`

cd $basedir
podman build -t jumpserver/core:v3.10.16-$TS .

exit 0
