FROM docker.io/almalinux/9-minimal AS build
ENV  VERSION=v3.10.16
WORKDIR /opt

RUN microdnf makecache ;\
    microdnf install -y --nodocs wget tar gzip rsync glibc-langpack-zh;\
    microdnf clean all
RUN wget https://github.com/jumpserver/koko/releases/download/${VERSION}/koko-${VERSION}-linux-amd64.tar.gz ; \
    tar zxvf koko-${VERSION}-linux-amd64.tar.gz ; \
    mv koko-${VERSION}-linux-amd64 koko;\
    rm -rf koko/{kubectl,helm}

FROM docker.io/almalinux/9-minimal
WORKDIR /data
RUN microdnf makecache ;\
    microdnf install -y --nodocs wget tar gzip rsync glibc-langpack-zh;\
    microdnf clean all

COPY --from=build /opt/koko /opt/koko
ADD --chmod=755 entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
CMD        [ "/data/koko/koko" ]
EXPOSE     2222
EXPOSE     5000
