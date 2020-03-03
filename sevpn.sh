#!/bin/bash
clear
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
echo ""
echo "Initiating Setup..."

apt update
apt install build-essential wget curl -y
apt upgrade -y
wget http://www.softether-download.com/files/softether/v4.32-9731-beta-2020.01.01-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.32-9731-beta-2020.01.01-linux-x64-64bit.tar.gz
tar xvzf softether-vpnserver* && rm -rf softether-vpnserver*
cd vpnserver && make i_read_and_agree_the_license_agreement && rm *.txt && curl -Os https://raw.githubusercontent.com/pxdlima/trifle/master/vpn_server.config
cd .. && mv vpnserver /usr/local && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver

test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver

chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
sysctl -w net.ipv4.ip_forward=1
sysctl -p
/usr/local/vpnserver/vpncmd localhost /SERVER /CMD OpenVpnMakeConfig ovpn
echo ""
echo "SoftetherVPN Server is now READY!"
