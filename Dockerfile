FROM docker.io/centos:centos8

ARG PKGS_LIST=main-packages-list.txt

COPY ${PKGS_LIST} /tmp/main-packages-list.txt

RUN dnf install -y python3 python3-requests && \
    curl https://raw.githubusercontent.com/openstack/tripleo-repos/master/tripleo_repos/main.py | python3 - -b master current-tripleo && \
    dnf upgrade -y && \
    dnf install -y $(cat /tmp/main-packages-list.txt) && \
    mkdir -p /var/lib/ironic-inspector && \
    sqlite3 /var/lib/ironic-inspector/ironic-inspector.db "pragma journal_mode=wal" && \
    pip3 install wheel pymemcache && \
    pip3 install -e "git+https://github.com/openstack/ironic-inspector.git#egg=ironic-inspector" && \
    dnf remove -y sqlite && \
    dnf clean all && \
    rm -rf /var/cache/{yum,dnf}/*

COPY ./inspector.conf.j2 /etc/ironic-inspector/ironic-inspector.conf.j2
# For non-standalone version
# COPY ./runironic-inspector.sh /bin/runironic-inspector
#
# For standalone version with apache revese proxy
COPY ./runironic-inspector-apache.sh /bin/runironic-inspector
COPY ./runhealthcheck.sh /bin/runhealthcheck
COPY ./ironic-common.sh /bin/ironic-common.sh
COPY ./ironic-inspector-common.sh /bin/ironic-inspector-common.sh
COPY ./runironic-inspector-api.sh /bin/runironic-inspector-api
COPY ./runironic-inspector-conductor.sh /bin/runironic-inspector-conductor
COPY ./inspector-api-apache.conf /etc/httpd/conf.d/inspector-api.conf
COPY ./inspector-apache.conf /etc/httpd/conf.d/inspector.conf
HEALTHCHECK CMD /bin/runhealthcheck
RUN chmod +x /bin/runironic-inspector /bin/runironic-inspector-api /bin/runironic-inspector-conductor 
RUN useradd inspector # For apache server to run inspetor api as a daemon

# RUN mkdir -p /var/log/ironic-inspector
# RUN mkdir -p /var/lib/ironic-inspector

ENTRYPOINT ["/bin/runironic-inspector"]
