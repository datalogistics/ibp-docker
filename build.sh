#!/bin/bash

export PREFIX=/opt

echo "Setting up BLiPP..."
cd blipp
sudo python2 setup.py develop
cd -

echo "Setting up libunis-c..."
cd libunis-c
./bootstrap.sh
./configure
make -j 4 && sudo make install
cd -

echo "Setting up IBP Server..."
cd ibp_server
cmake .
make -j 4
sudo make install
sudo mkdir -p /depot/ibp_resources
sudo -E bash -c 'cat <<EOF > /usr/local/etc/ibp/ibp.cfg
[server]
user=root
group=root
pidfile=/var/run/ibp_server.pid
interfaces=__HOSTNAME__:6714;
port=6714
lazy_allocate=1
threads=16
log_file=/var/log/ibp_server.log
activity_file=/var/log/ibp_activity.log

[unis]
name = IBP
type = ibp_server
endpoint = https://dlt.open.sice.indiana.edu:9000
protocol_name= ibp
registration_interval = 120
publicip = __PUBLIC_HOST__
publicport = 6714
use_ssl = 1
client_certfile=/etc/periscope/dlt-client.pem
client_keyfile=/etc/periscope/dlt-client.pem
institution = __INSTITUTION__
country = __COUNTRY__
state = __STATE__
city = __CITY__
zipcode = __ZIPCODE__
latitude = __LATITUDE__
longitude = __LONGITUDE__

EOF'
cd -
