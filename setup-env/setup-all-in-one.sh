#!/bin/bash

# Check we're running as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root!"
    exit 1
fi

apt-get update
apt-get install git -y
git clone https://github.com/sunnyzh2012/dodai-deploy.git

cd dodai-deploy/setup-env
./setup.sh -x "$http_proxy" server
./setup.sh -s `hostname -f` -x "$http_proxy" node
./setup-storage-for-swift.sh loopback /srv/node sdb1 4

cd ..
script/start-servers production
