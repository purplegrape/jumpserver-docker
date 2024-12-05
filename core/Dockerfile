FROM docker.io/almalinux/9-minimal as build-stage-1
RUN microdnf makecache ;\
    microdnf install -y --nodocs epel-release wget tar gzip gettext openssh-clients sshpass procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y --nodocs gcc gcc-c++ make automake autoconf libtool mariadb-devel postgresql-devel freerdp-devel openldap-devel openssl-devel libxml2-devel xmlsec1-openssl-devel --enablerepo=crb;\ 
    microdnf install -y --nodocs python3.11-devel python3.11-pip python3.11-setuptools;\
    microdnf clean all

RUN wget https://github.com/jumpserver/jumpserver/releases/download/v3.10.16/jumpserver-v3.10.16.tar.gz 
RUN tar zxvf jumpserver-*.tar.gz -C /opt ; mv /opt/jumpserver-* /opt/jumpserver; 
RUN pip3.11 install poetry==1.8.3
RUN cd /opt/jumpserver; poetry export --without-hashes --output requirements.txt
RUN chown -R nobody:nobody /opt/jumpserver

########################################################

FROM docker.io/almalinux/9-minimal AS build-stage-2
RUN microdnf makecache ;\
    microdnf install -y --nodocs epel-release wget tar gzip gettext openssh-clients sshpass procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y --nodocs gcc gcc-c++ make automake autoconf libtool mariadb-devel postgresql-devel freerdp-devel openldap-devel openssl-devel libxml2-devel xmlsec1-openssl-devel --enablerepo=crb;\ 
    microdnf install -y --nodocs python3.11-devel python3.11-pip python3.11-setuptools;\
    microdnf clean all

COPY --from=build-stage-1 /opt/jumpserver /opt/jumpserver
RUN python3.11 -m venv /opt/py3
RUN . /opt/py3/bin/activate; pip3.11 install -U pip setuptools; pip3.11 install --no-cache-dir -r /opt/jumpserver/requirements.txt

########################################################

FROM docker.io/almalinux/9-minimal
ENV VIRTUAL_ENV=/opt/py3
ENV PATH=/opt/py3/bin:$PATH

COPY --from=build-stage-1 /opt/jumpserver /opt/jumpserver
COPY --from=build-stage-2 /opt/py3 /opt/py3

RUN microdnf makecache ;\
    microdnf install -y --nodocs wget tar gzip rsync iproute gettext openssh-clients sshpass procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y --nodocs python3.11 python3.11-pip python3.11-setuptools;\
    microdnf clean all

ADD --chmod=755 entrypoint.sh /

USER root
WORKDIR /data/jumpserver
ENTRYPOINT [ "/entrypoint.sh" ]

USER nobody
WORKDIR /data/jumpserver
CMD [ "/data/jumpserver/jms", "start"]
EXPOSE 8080
