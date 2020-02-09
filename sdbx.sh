#!/bin/bash
rm -rf /usr/local/utorrent && rm /usr/bin/utserver
echo "Removing previous uTorrent Server installation..."
sleep 3
clear
cd /usr/local/
echo "Downloading zipped binary.."
wget -q http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0
sleep 2
tar xvf linux-x64-debian-7-0
rm linux-x64-debian-7-0
mv /usr/local/utorrent-server-alpha-v3_3/ /usr/local/utorrent && cd /usr/local/utorrent
apt install libssl-dev -y
wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
rm libssl1.0.0_1.0.2n-1ubuntu5.3_amd64.deb
echo "Setting up server settings.."
touch dht.dat
touch rss.dat
touch resume.dat
touch webcache.dat
sleep 2
wget -q https://github.com/pxdlima/pxdlima-config/raw/master/settings.dat
ln -s /usr/local/utorrent/utserver /usr/bin/utserver
echo "Completing installation and starting up server.."
sleep 2
utserver -logfile /usr/local/utorrent/server.log -daemon
