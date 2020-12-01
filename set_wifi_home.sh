#!/bin/bash
#
#https://developer.gnome.org/NetworkManager/stable/nm-settings-nmcli.html
#
#
function set_connection
{
echo "Setting connection $1"
#
# on raspberry 'if-name' doesnot work. Must be ifname.
nmcli connection add type wifi ifname wlan0 con-name $1 autoconnect yes ssid $1 ip4 $2 gw4 $3
echo "set dns"
nmcli connection modify $1 ipv4.dns "$4"
echo "set ipv4 and ipv6 methods"
nmcli connection modify $1 ipv4.method $5
nmcli connection modify $1 ipv6.method $6
echo "set priority"
nmcli connection modify $1 connection.autoconnect-priority $7 
echo "set security"
nmcli connection modify $1 wifi-sec.key-mgmt $8
nmcli connection modify $1 wifi-sec.psk $9
echo "all done for $1"
echo " "
}


read -p "Es mASTER (.211) o sLAVE (.212)  (m/s default m) -> " master
#
if [ "$master" == "s" ]
then
    tipo="slave"
    ipv4=192.168.1.212
else
    tipo="master"
    ipv4=192.168.1.211
fi
#
echo "Asigno tipo $tipo con IP estática $ipv4"
#
IP4="$ipv4/24"
GW4="192.168.1.1"
DN4="80.58.61.250 80.58.61.254"
DH4="manual"
DH6="ignore"
PSW="4z4dYm6VqtA2avaTwzFw"
#
# $1 connection, SSID name (MOVISTAR_442D)
# $2 ipv4 address
# $3 gateway address
# $4 dns servers
# $5 ipv4 dhcp mode
# $6 ipv6 dhcp mode
# $7 priority
# $8 security mode
# $9 password
#                  $1              $2   $3    $4    $5   $6  $7    $8     $9
set_connection FRITZ_442D         $IP4 $GW4 "$DN4" $DH4 $DH6  4  wpa-psk $PSW
set_connection FRITZ_PLUS_442D    $IP4 $GW4 "$DN4" $DH4 $DH6  6  wpa-psk $PSW
set_connection MOVISTAR_442D      $IP4 $GW4 "$DN4" $DH4 $DH6  3  wpa-psk $PSW
set_connection MOVISTAR_PLUS_442D $IP4 $GW4 "$DN4" $DH4 $DH6  2  wpa-psk $PSW
#
echo "All connections set"
echo "Voy a connectar con home wifi para tener acceso a internet"
echo "Si estás utilizando VNC deberas cambiar tu ordenador a la home wifi, "
echo "cerrar esta sesión de VNC-stellarmate y abrir otra a VNC-master o VNC-slave"
#
read -p "Pulsa una tecla para intentar la conexion" preparado
#
nmcli connection up id MOVISTAR_442D
#
read -p "¿Estas de nuevo aquí?" i_am_here
#
echo "Perfect. Setup goes on"
#
nmcli connection modify stellarmate connection.autoconnect-priority -50
#
echo "Home wifi conectada"

