#!/usr/bin/bash
source /bin/ironic-inspector-common.sh
sed -i "/Listen 80/c\#Listen 80" /etc/httpd/conf/httpd.conf
exec /usr/sbin/httpd -DFOREGROUND

