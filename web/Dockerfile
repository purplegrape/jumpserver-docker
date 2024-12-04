FROM docker.io/almalinux/9-minimal AS build
ENV  VERSION=v3.10.16
WORKDIR /opt/webroot

RUN microdnf makecache ;\
    microdnf install -y --nodocs wget tar gzip rsync iproute procps-ng glibc-langpack-zh;\
    microdnf clean all
RUN wget https://github.com/jumpserver/lina/releases/download/v3.10.16/lina-v3.10.16.tar.gz \
         https://github.com/jumpserver/luna/releases/download/v3.10.16/luna-v3.10.16.tar.gz ;
RUN tar zxvf lina-${VERSION}.tar.gz ; tar zxvf luna-${VERSION}.tar.gz ; rm -rf *.tar.gz
RUN mv luna-* luna ;mv lina-* ui

FROM docker.io/almalinux/9-minimal
WORKDIR /data
COPY --from=build /opt/webroot /opt/webroot
ADD --chmod=644 nginx.conf /etc/nginx/
ADD --chmod=755 entrypoint.sh /

RUN microdnf makecache; microdnf install -y --nodocs rsync nginx-core; microdnf clean all
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/nginx/access.log

ENTRYPOINT [ "/entrypoint.sh" ]
CMD        [ "/usr/sbin/nginx" ]
EXPOSE     80
