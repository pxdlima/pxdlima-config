#!/bin/bash

clear
if [ -d /usr/local/utorrent ]; then
	echo "uTorrent detected.. Exit"
	rm -rf /usr/local/utorrent
	rm /usr/bin/utserver
else
rm -rf /usr/local/utorrent
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
cd /usr/local/
echo "Downloading zipped binary.."
wget -q http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-debian-7-0
wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5_amd64.deb
DEBIAN_FRONTEND=noninteractive apt-get -yqq install libssl-dev 
sleep 1
tar xf linux-x64-debian-7-0 
dpkg -i libssl1.0.0* > /dev/null
rm linux-x64-debian-7-0 && rm *.deb
mv /usr/local/utorrent-server-alpha-v3_3/ /usr/local/utorrent && cd /usr/local/utorrent
echo "Configuring startup files."
touch dht.dat
touch rss.dat
touch resume.dat
touch webcache.dat
wget -q https://github.com/pxdlima/trifle/raw/master/files/settings.dat
ln -s /usr/local/utorrent/utserver /usr/bin/utserver > /dev/null
echo "[Unit]
Description=uTorrent service.

[Service]
Type=simple
ExecStart=/usr/bin/utserver -settingspath /usr/local/utorrent/ -logfile /usr/local/utorrent/server.log

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/utorrent.service
systemctl daemon-reload
systemctl enable utorrent.service
service utorrent start 
echo "Installation Complete!"
fi
