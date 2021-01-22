FROM docker.io/centos:centos8

ARG PKGS_LIST=main-packages-list.txt

COPY ${PKGS_LIST} /tmp/main-packages-list.txt
COPY prepare-image.sh /bin/

RUN prepare-image.sh && \
  rm -f /bin/prepare-image.sh

COPY ironic-inspector.conf.j2 /etc/ironic-inspector/
COPY scripts/ /bin/

COPY __init__.py /usr/lib/python3.6/site-packages/eventlet/hubs/__init__.py

HEALTHCHECK CMD /bin/runhealthcheck

ENTRYPOINT ["/bin/runironic-inspector"]
