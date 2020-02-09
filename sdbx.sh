#!/bin/bash
mkdir /usr/local/utorrent && cd /usr/local/utorrentnetsta
wget http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0
rm linux-x64-debian-7-0
tar zxvf linux-x64-debian-7-0
apt-get install libssl-dev
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
rm libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
