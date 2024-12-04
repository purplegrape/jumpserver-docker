由于docker镜像的不可变特性, 容器启动时会根据条件(如果 /data 为空)，从 /opt 释放文件到存储卷 /data, 参考 entrypoint.sh 。

镜像只负责环境，程序的启动和读写都发生在存储卷/data 里。

首次启动镜像可能会出现启动失败的情况，是因为容器释放的是初始配置文件，没有经过修改。

经历过首次启动失败之后, 存储卷 /data 下会出现一些目录和文件，请根据需要进行修改。

#### 下列文件需要进行适当修改
```
/data/jumpserver/config.yml  
/data/koko/config.yml  
/data/nginx/*  
```

#### 初始化 jumpserver core

```
cd /data/jumpserver
rm -f apps/locale/zh/LC_MESSAGES/django.mo
python3.11 apps/manage.py compilemessages

```

#### 初始化 koko