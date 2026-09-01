FROM alpine:latest
LABEL maintainer="Yvan Margreth <github.com/ymargreth>"
LABEL source="https://github.com/ymargreth/nas-server-alpine"
LABEL branch="master"
COPY Dockerfile README.md compose.yml /

RUN apk add --no-cache --update --verbose nfs-utils bash iproute2 && \
    rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot && \
    mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
    echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab && \
    addgroup -g 10000 zfsaccess && \
    adduser -u 1000 -G zfsaccess -s /sbin/nologin -DH zfsbrowser

COPY exports /etc/
COPY nfsd.sh /usr/bin/nfsd.sh
COPY .bashrc /root/.bashrc

RUN chmod +x /usr/bin/nfsd.sh

ENTRYPOINT ["/usr/bin/nfsd.sh"]
