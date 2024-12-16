FROM docker.io/almalinux/9-minimal AS build-stage-1
ENV VERSION=v3.10.16
WORKDIR /opt
RUN microdnf makecache ;\
    microdnf install -y epel-release wget tar gzip zip unzip gettext openssh-clients sshpass procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y gcc gcc-c++ make automake autoconf libtool mariadb-devel postgresql-devel freerdp-devel openldap-devel openssl-devel;\
    microdnf install -y python3.11-devel python3.11-pip python3.11-setuptools;\
    microdnf clean all

RUN wget https://github.com/jumpserver/jumpserver/releases/download/${VERSION}/jumpserver-${VERSION}.tar.gz \
         https://github.com/jumpserver/lina/releases/download/${VERSION}/lina-${VERSION}.tar.gz \
         https://github.com/jumpserver/luna/releases/download/${VERSION}/luna-${VERSION}.tar.gz \
         https://github.com/jumpserver/koko/releases/download/${VERSION}/koko-${VERSION}-linux-amd64.tar.gz \
         https://github.com/jumpserver/lion/releases/download/${VERSION}/lion-${VERSION}-linux-amd64.tar.gz
RUN for i in `ls *.tar.gz`;do tar zxvf $i;rm -rf $i;done

RUN python3.11 -m venv /opt/py3
RUN . /opt/py3/bin/activate; pip3.11 install -U pip setuptools; pip3.11 install poetry==1.8.3
RUN cd /opt/jumpserver-${VERSION}; poetry config virtualenvs.create false; poetry install

## ----------------------------------------------------------
FROM docker.io/almalinux/9-minimal
ENV VERSION=v3.10.16
ENV VIRTUAL_ENV=/opt/py3
ENV PATH=/opt/py3/bin:$PATH

RUN microdnf module enable nginx:1.24 mariadb:10.11 redis:7; \
    microdnf install -y epel-release ; microdnf makecache ;\
    microdnf install -y --nodocs wget tar gzip rsync gettext mariadb openldap openssh-clients sshpass freerdp lrzsz iproute procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y --nodocs python3.11 python3.11-pip python3.11-setuptools supervisor;\
    microdnf clean all

COPY --from=build-stage-1 /opt /opt

RUN microdnf makecache; microdnf install -y --nodocs python3.11 rsync nginx-core redis; microdnf clean all

ADD --chmod=644 nginx.conf /etc/nginx/
ADD --chmod=644 supervisord.conf /etc/
ADD --chmod=755 entrypoint.sh /

RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/nginx/access.log

WORKDIR /data
ENTRYPOINT [ "/entrypoint.sh" ]
CMD        [ "/usr/bin/supervisord", "-n" ]
EXPOSE     80
