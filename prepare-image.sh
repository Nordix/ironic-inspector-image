 #!/usr/bin/bash

set -ex
 
dnf install -y python3 python3-requests 
curl https://raw.githubusercontent.com/openstack/tripleo-repos/master/tripleo_repos/main.py | python3 - -b master current-tripleo
dnf upgrade -y
dnf install -y $(cat /tmp/main-packages-list.txt)
pip3 install wheel
pip3 install git+git://github.com/namnx228/ironic-inspector.git#egg=ironic-inspector
mkdir -p /var/lib/ironic-inspector
sqlite3 /var/lib/ironic-inspector/ironic-inspector.db "pragma journal_mode=wal"
dnf remove -y sqlite
dnf clean all
rm -rf /var/cache/{yum,dnf}/*
