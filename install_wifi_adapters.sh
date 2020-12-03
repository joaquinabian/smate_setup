#!/bin/bash
#
#
read -r -p "Select which drivers instalL: 1) RTL8821CU 2) RTL8812AU 3) All [default]" drivers
drivers=${drivers:-3}
#
#
################################### install requirements ###########################################
echo
echo "*** installing git bc y dkms requirements ***"
echo
echo "*** installing git"
sudo apt -y install git
echo
echo "*** installing bc"
sudo apt -y install bc
echo
echo "*** installing dkms"
sudo apt -y install dkms
echo
echo "*** installing raspi kernel headers"
sudo apt install raspberrypi-kernel-headers
echo
#
echo "*** preparing usbwifi folder"
#
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#
if [ ! -d "$DIR"/usbwifi ]
then
    mkdir -m777 "$DIR"/usbwifi
fi
#
cd "$DIR"/usbwifi || exit
#
####################################### INSTALL DRIVERS ############################################
#
case $drivers in
1)
install_rtl8821cu
;;
2)
install_rtl8812au
;;
3)
install_rtl8821cu
install_rtl8812au
;;
esac
#
########################################  RTL8821CU ################################################
#
function install_rtl8821cu
{
echo "***** install RTL8821CU ******"
echo " "
sudo cp /lib/modules/"$(uname -r)"/build/arch/arm/Makefile /lib/modules/"$(uname -r)"/build/arch/arm/Makefile."$(date +%Y%m%d%H%M)"
sudo sed -i 's/-msoft-float//' /lib/modules/"$(uname -r)"/build/arch/arm/Makefile
sudo ln -s /lib/modules/"$(uname -r)"/build/arch/arm /lib/modules/"$(uname -r)"/build/arch/armv7l
echo " "
#
echo "*** getting git clone"
git clone https://github.com/brektrou/rtl8821CU.git || exit 1
mv rtl8821CU rtl8821CU_BT || exit 1
cd rtl8821CU_BT/ || exit 1
#
echo "*** build and install"
# method 1
make
sudo make install || exit 1
#
#method 2
#sudo ./dkms-install.sh
#
# module is installed on /lib/modules/<linux version>/kernel/drivers/net/wireless/realtek/rtl8821cu
#
echo " "
echo "Driver for 'RasPi Dual-Band USB 2 WiFi Adapter with Antenna' Installed"
echo " "
#
# modprobe intelligently adds or removes a module from the Linux kernel
# modprobe looks in the module directory /lib/modules/'uname -r'
# modprobe 8821cu
#
# Una vez instalado comprobar:
# iwconfig wlan0 | grep -i --color quality
# wconfig wlan1 | grep -i --color quality
}
#
######################################   RTL8812AU   ###############################################
# For the KuWFi USB WiFi ADAPTER 
# https://github.com/aircrack-ng/rtl8812au
#
function install_rtl8812au
{
echo "***** install RTL8812AU ******"
echo " "
#
#
cd "$DIR"/usbwifi || exit 1
echo
echo "** getting git clone"
git clone -b v5.6.4.2 https://github.com/aircrack-ng/rtl8812au.git || exit 1
cd rtl* || exit 1
#
#mv rtl8812au rtl8814AU_AC
#cd rtl8814AU_AC/
#
echo "** modify Makefile"
sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile
#
echo "** modify dkms files"
sed -i 's/^dkms build/ARCH=arm dkms build/' dkms-install.sh
sed -i 's/^MAKE="/MAKE="ARCH=arm\ /' dkms.conf
#
echo "** make dkms_install"
sudo make dkms_install || exit 1
#
echo
echo "** Driver for KuWFi USB WiFi ADAPTER Installed **"
echo
#
# the driver 88XXau.ko is in:
#    /var/lib/dkms/rtl8812au/5.6.4.2/5.4.51-v7l+/armv7l/module
# Connect device to USB3 hub
# Inmediately it searchs for wifi
# In network manager -> Edit Connections, for each connection:
# in Wi-Fi tab select the new Device
# remove the old adapter
# remove all connections created while the two adapters were connected.
}

exit 0
