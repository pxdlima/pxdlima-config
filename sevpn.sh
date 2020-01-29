#!/bin/bash
clear

echo ""
echo "Initiating Setup..."

sleep 1
apt update
apt upgrade -y
apt install build-essential -y
apt install wget -y
wget http://www.softether-download.com/files/softether/v4.32-9731-beta-2020.01.01-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.32-9731-beta-2020.01.01-linux-x64-64bit.tar.gz
tar xvzf softether-vpnserver* && rm -rf softether-vpnserver*
cd vpnserver && make i_read_and_agree_the_license_agreement
cd && mv vpnserver /usr/local && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
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
###
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start
sysctl -w net.ipv4.ip_forward=1
sysctl -p

TARGET="/usr/local/"
USER="pxdlima"
HUB="VPN"
SE_PASSWORD="FauxPas1!"
sleep 2
${TARGET}vpnserver/vpncmd localhost /SERVER /CMD ServerPasswordSet ${SE_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD VpnOverIcmpDnsEnable /ICMP:no /DNS:no
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD KeepDisable
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD SstpEnable no
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD OpenVpnEnable yes /PORTS:443
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD IPsecEnable /L2TP:no /L2TPRAW:no /ETHERIP:no /PSK:_ /DEFAULTHUB:${HUB}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD HubDelete DEFAULT
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD HubCreate ${HUB} /PASSWORD:${SE_PASSWORD}
sleep 2
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD UserCreate ${USER} /GROUP:none /REALNAME:none /NOTE:none
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD UserAnonymousSet ${USER}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD SecureNatEnable
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD LogDisable Packet
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD SecureNatHostSet /MAC:none /IP:10.10.11.11 /MASK:255.255.255.192
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD DhcpSet /START:10.10.11.1 /END:10.10.11.10 /MASK:255.255.255.192 /EXPIRE:7200 /GW:10.10.11.11 /DNS:67.207.67.2 /DNS2:none /DOMAIN:ecosia.org /LOG:no
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /HUB:${HUB} /CMD NatSet /MTU:1500 /TCPTIMEOUT:300 /UDPTIMEOUT:60 /LOG:no
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ListenerDelete 5555
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ListenerDelete 1194
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SE_PASSWORD} /CMD ListenerDelete 992
sleep 1

echo "SoftetherVPN Server is now READY!"
echo " "
echo "Virtual Hub: ${HUB}"
echo "Port: 443"
echo "Username: ${USER} - Anonymous Authentication"
echo "Server Password: ${SE_PASSWORD}"
echo " "
