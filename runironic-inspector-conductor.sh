#!/usr/bin/bash
source /bin/ironic-inspector-common.sh
crudini --set $CONFIG DEFAULT standalone false
memcached -u apache & 
exec /usr/local/bin/ironic-inspector-conductor $CONFIG_OPTIONS

