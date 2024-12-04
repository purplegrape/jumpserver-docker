#download
FROM docker.io/almalinux/9-init as build-stage-1
ENV VERSION=v3.10.16
WORKDIR /data

RUN yum makecache; yum install -y --nodocs wget tar 
RUN wget https://github.com/jumpserver/jumpserver/releases/download/${VERSION}/jumpserver-${VERSION}.tar.gz
RUN tar zxvf jumpserver-${VERSION}.tar.gz -C /opt ; mv /opt/jumpserver-${VERSION} /opt/jumpserver

########################################################

FROM docker.io/almalinux/9-init as build-stage-2
ENV VERSION=v3.10.16
ENV PATH=/opt/py3/bin:$PATH
WORKDIR /opt/jumpserver

RUN yum makecache; yum install -y --nodocs epel-release wget tar gettext openssh-clients sshpass procps-ng glibc-langpack-zh

COPY --from=build-stage-1 /opt/jumpserver /opt/jumpserver

# devel libs
RUN yum install -y --nodocs gcc gcc-c++ make automake autoconf libtool mariadb-devel postgresql-devel freerdp-devel openldap-devel openssl-devel libxml2-devel xmlsec1-openssl-devel --enablerepo=crb

RUN yum install -y --nodocs python3.11-devel python3.11-pip python3.11-setuptools
RUN pip3.11 install -U pip virtualenv
RUN python3.11 -m venv /opt/py3
RUN pip3.11 install -U pip; pip3.11 install poetry==1.8.3
RUN poetry config virtualenvs.create false  ; . /opt/py3/bin/activate ; poetry install
RUN rm -rf apps/locale/zh/LC_MESSAGES/django.mo apps/locale/en/LC_MESSAGES/django.mo
RUN django-admin compilemessages

########################################################
# final
FROM docker.io/almalinux/9-minimal
ENV  VERSION=v3.10.16
ENV  PATH=/opt/py3/bin:$PATH
WORKDIR /data

COPY --from=build-stage-1 /opt/jumpserver /opt/jumpserver
COPY --from=build-stage-2 /opt/py3 /opt/py3

RUN microdnf makecache ;\
    microdnf install -y epel-release ;\
    microdnf install -y --nodocs wget tar rsync iproute gettext openssh-clients sshpass procps-ng glibc-langpack-zh vim-minimal;\
    microdnf install -y --nodocs python3.11 python3.11-pip python3.11-setuptools;\
    microdnf clean all

ADD --chmod=755 entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
CMD        [ "/data/jumpserver/jms", "start"]
EXPOSE     8080
