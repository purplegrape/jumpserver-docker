FROM centos:8 as build-stage-1
ENV VERSION=v2.16.1
WORKDIR /usr/share
RUN dnf install -y git gcc gcc-c++ make mysql-devel postgresql-devel gd-devel openssl-devel openldap-devel protobuf-c-devel python3-pip python3-setuptools python3-virtualenv python3-pillow python3-devel && dnf clean all
RUN git clone -b $VERSION --depth=1 https://github.com/jumpserver/jumpserver jumpserver
RUN python3 -m venv jumpserver-python3-venv && source jumpserver-python3-venv/bin/activate && pip3 --no-cache-dir --disable-pip-version-check install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -r jumpserver/requirements/requirements.txt

FROM centos:8 as build-stage-2
ENV VERSION=v2.16.1
WORKDIR /usr/share
RUN yum install -y git
RUN git clone -b ${VERSION} --depth=1 https://github.com/jumpserver/lina jumpserver-lina

FROM centos:8 as build-stage-3
ENV VERSION=v2.16.1
WORKDIR /usr/share
RUN yum install -y git
RUN git clone -b ${VERSION} --depth=1 https://github.com/jumpserver/luna jumpserver-luna

FROM centos:8 as build-stage-4
ENV VERSION=v2.16.1
WORKDIR /var/lib
RUN yum install -y wget
RUN wget https://github.com/jumpserver/koko/releases/download/${VERSION}/koko-${VERSION}-linux-amd64.tar.gz
RUN tar zxf koko-${VERSION}-linux-amd64.tar.gz && mv koko-${VERSION}-linux-amd64 koko && mv koko/koko /usr/bin/koko
RUN mkdir -p koko/data && rm -rf koko/{config_example.yml,init-kubectl.sh,kubectl}

FROM centos:8 as build-stage-5
ENV VERSION=v2.16.1
WORKDIR /var/lib
RUN yum install -y wget
RUN wget https://github.com/jumpserver/lion-release/releases/download/${VERSION}/lion-${VERSION}-linux-amd64.tar.gz
RUN tar zxf lion-${VERSION}-linux-amd64.tar.gz && mv lion-${VERSION}-linux-amd64 lion && mv lion/lion /usr/bin/lion

FROM centos:8
WORKDIR /usr/share
RUN dnf install -y epel-release
RUN dnf install -y mysql postgresql gd openldap python3-pip python3-setuptools python3-virtualenv sshpass initscripts chkconfig guacd nginx redis && dnf clean all
RUN systemctl enable nginx.service redis.service guacd.service

COPY --from=build-stage-1 /usr/share/jumpserver-python3-venv /usr/share/jumpserver-python3-venv
COPY --from=build-stage-1 /usr/share/jumpserver /usr/share/jumpserver
COPY --from=build-stage-2 /usr/share/jumpserver-lina /usr/share/jumpserver-lina
COPY --from=build-stage-3 /usr/share/jumpserver-luna /usr/share/jumpserver-luna
COPY --from=build-stage-4 /usr/bin/koko /usr/bin/koko
COPY --from=build-stage-4 /var/lib/koko /var/lib/koko
COPY --from=build-stage-5 /usr/bin/lion /usr/bin/lion
COPY --from=build-stage-5 /var/lib/lion /var/lib/lion

COPY ./koko.config.yml /etc/koko/config.yml
COPY ./koko.service /etc/systemd/system/koko.service
COPY ./lion.config.yml /etc/lion/config.yml
COPY ./lion.service /etc/systemd/system/lion.service
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./jumpserver.config.yml /usr/share/jumpserver/config.yml
COPY ./jumpserver.init /etc/rc.d/init.d/jumpserver

RUN getent group  fit2cloud >/dev/null || groupadd -r fit2cloud
RUN getent passwd fit2cloud >/dev/null || useradd -r -g fit2cloud -s /sbin/nologin -d /var/lib/jumpserver fit2cloud
RUN rm -rf jumpserver/apps/locale/zh/LC_MESSAGES/django.mo
RUN mkdir -p /etc/{jumpserver,koko,lion} /var/lib/{jumpserver,koko,lion} /var/log/{jumpserver,koko,lion}
RUN chown -R fit2cloud.fit2cloud /var/lib/{jumpserver,koko,lion} /var/log/{jumpserver,koko,lion} /usr/share/jumpserver 
RUN chmod 755 /etc/rc.d/init.d/jumpserver
RUN systemctl enable jumpserver.service koko.service lion.service

VOLUME [ "/var/lib/jumpserver" ]
VOLUME [ "/var/lib/koko" ]
VOLUME [ "/var/lib/lion" ]
VOLUME [ "/var/lib/redis" ]
VOLUME [ "/usr/share/jumpserver/data" ]
VOLUME [ "/usr/share/jumpserver/logs" ]

EXPOSE 80
CMD ["/usr/sbin/init"]
