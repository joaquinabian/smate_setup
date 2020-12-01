#!/bin/bash
#
#https://developer.gnome.org/NetworkManager/stable/nm-settings-nmcli.html
#
#
function set_connection
{
echo "Setting connection $1 for $tipo"
#
nmcli connection add type wifi ifname wlan0 con-name $1 autoconnect yes ssid $1
echo "set ipv4 and ipv6 methods"
nmcli connection modify $1 ipv4.method $2
nmcli connection modify $1 ipv6.method $3
echo "set priority"
nmcli connection modify $1 connection.autoconnect-priority $4
echo "set security" 
nmcli connection modify $1 wifi-sec.key-mgmt $5
nmcli connection modify $1 wifi-sec.psk $6
echo "all done for $1"
echo " "
}

#
echo "La IP estatica se asigna en el router"
echo "quizás debería hacerse como en el caso del home-network (asignarlo manualmente)" 
#
IP4=""
GW4=""
DN4=""
DH4="auto"
DH6="auto"
PSW="83817472"
#
# $1 connection, SSID name (MOVISTAR_442D)
# $2 ipv4 dhcp mode
# $3 ipv6 dhcp mode
# $4 priority
# $5 security mode
# $6 password
#                  $1         $2  $3  $4     $5    $6  
set_connection TP-LINK_446C $DH4 $DH6 50  wpa-psk $PSW

echo "***  All connections set  ***"

