#!/bin/bash

HOSTNAME=`hostname`
IBP_CFG="/usr/local/etc/ibp/ibp.cfg"
BLIPP_CFG="/etc/periscope/blippd.json"

SUBS=( "HOSTNAME"
       "PUBLIC_HOST"
       "INSTITUTION"
       "COUNTRY"
       "STATE"
       "CITY"
       "ZIPCODE"
       "LATITUDE"
       "LONGITUDE" )

[ -z "$PUBLIC_HOST" ] && PUBLIC_HOST=$HOSTNAME
[ -z "$INSTITUTION" ] && INSTITUTION="EODN"
    
for i in "${SUBS[@]}"; do
    sudo sed -i "s/__${i}__/${!i}/" $IBP_CFG
    sudo sed -i "s/__${i}__/${!i}/" $BLIPP_CFG
done

sudo mkdir -p /depot/ibp_resources /depot/db

if [ -z "$MAX_MBYTES" ]; then
    sudo mkfs.resource 1 dir /depot/ibp_resources /depot/db | sudo tee -a ${IBP_CFG} > /dev/null
else
    sudo mkfs.resource 1 dir /depot/ibp_resources /depot/db -b ${MAX_MBYTES} | sudo tee -a ${IBP_CFG} > /dev/null
fi
# 100MB min free
sudo sed -i "s/^minfree_size.*/minfree_size = 100/" $IBP_CFG

cat $IBP_CFG

sudo ibp_server -d $IBP_CFG
get_version $HOSTNAME

sudo blippd -c /etc/periscope/blippd.json -D -l /var/log/blippd.log

echo "IBP Container IP : `hostname --ip-address`"

while [ ! -f /var/log/ibp_server.log ]
do
    sleep 1
done
tail -f /var/log/ibp_server.log
