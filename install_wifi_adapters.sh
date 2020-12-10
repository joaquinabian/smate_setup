#!/bin/bash
#
#
UNAME=$(uname -r)
DATE=$(date +%Y%m%d%H%M)
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#
#
function ask() {
    question=$(cat <<- EOF
    Select which driver to install:
       1.- brektrou RTL8821CU
       2.- aircrag  RTL8814AU
       3.- fars     RTL8821CU
       4.- fars     RTL8814AU
       5.- FINISH (default) ....  >  
EOF
)
    #
    read -r -p "$question" drivers
    drivers=${drivers:-5}
    #
}
#
#
function create_wifi_directory() {
    echo "*** preparing usbwifi folder"
    #
    if [ ! -d "$DIR"/usbwifi ]
    then
        mkdir -m777 "$DIR"/usbwifi
    fi
    #
    cd "$DIR"/usbwifi || exit 1
}
#
#
function install_requirements() {
    echo
    echo "*** installing git, bc, dkms & kernel header requirements ***"
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
}
#
#
function get_fars_robotics() {
    if [ ! -f "/usr/bin/install-wifi" ]
    then
        echo "*** wget install-wifi from fars-robotics  ***"
        sudo wget http://www.fars-robotics.net/install-wifi -O /usr/bin/install-wifi
        sudo chmod +x /usr/bin/install-wifi
    else
        echo "install-wifi from fars-robotics already installed"
    fi
}
#
#
###########################  RTL8821CU brektrou (1)  ###########################
# For the Dual Band Wifi Adapter with Antenna (The PiHut)
# https://github.com/brektrou/rtl8821CU
function install_rtl8821cu_brkt() {
    echo "***** install RTL8821CU ******"
    echo

    sudo cp -p /lib/modules/"$UNAME"/build/arch/arm/Makefile \
               /lib/modules/"$UNAME"/build/arch/arm/Makefile."$DATE"
    sudo sed -i 's/-msoft-float//' /lib/modules/"$UNAME"/build/arch/arm/Makefile
    sudo ln -s /lib/modules/"$UNAME"/build/arch/arm /lib/modules/"$UNAME"/build/arch/armv7l
    echo
    #
    echo "*** getting git clone"
    git clone https://github.com/brektrou/rtl8821CU.git || exit 1
    mv rtl8821CU rtl8821CU_BT || exit 1
    cd rtl8821CU_BT || exit 1
    #
    echo "*** build and install"
    #
    ### method 1
    #make
    #sudo make install || exit 1
    #
    ### method 2
    # DKMS is a system which will automatically recompile and install a kernel 
    # module when a new kernel gets installed or updated.
    sudo ./dkms-install.sh
    #
    # driver module is installed on:
    # /lib/modules/<linux version>/kernel/drivers/net/wireless/realtek/rtl8821cu
    # modprobe intelligently adds or removes a module from the Linux kernel.
    # if module no indicated, modprobe looks in the module directory /lib/modules/'uname -r'
    # cd /lib/modules/"$UNAME"/kernel/drivers/net/wireless/realtek/rtl8821cu || exit 1
    sudo modprobe 8821cu
    #
    echo
    echo "Driver for 'RasPi Dual-Band USB 2 WiFi Adapter with Antenna' Installed"
    echo
    #
    # Recover original Makefile
    sudo cp -p /lib/modules/"$UNAME"/build/arch/arm/Makefile."$DATE" \
               /lib/modules/"$UNAME"/build/arch/arm/Makefile
    #
    # Una vez instalado comprobar:
    # iwconfig wlan0 | grep -i --color quality
    # wconfig wlan1 | grep -i --color quality
}
#
#
############################  RTL8814AU aircrrag (2) ###########################
#
function install_rtl8814au_rcrg() {
    # For the KuWFi USB WiFi ADAPTER 
    # https://github.com/aircrack-ng/rtl8812au
    echo "***** install RTL8814AU ******"
    echo
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
    # no dkms-install en repository !! -- ? -->
    #sed -i 's/^dkms build/ARCH=arm dkms build/' dkms-install.sh  
    sed -i 's/^MAKE="/MAKE="ARCH=arm\ /' dkms.conf
    #
    ### method 1
    # The make install doesnt work, gives error:
    # gcc: error: unrecognized command line option ´-mgeneral-regs-only´
    #make
    #sudo make install || exit 1
    #
    #
    ### method 2
    # 
    echo "** make dkms_install"
    sudo make dkms_install || exit 1
    #
    echo
    echo "** Driver for KuWFi USB WiFi ADAPTER Installed **"
    echo
    #
    # the driver 88XXau.ko is in:
    #    /var/lib/dkms/8812au/5.6.4.2_35491.20191025/5.4.72-v7l+/armv7l/module/88XXau.ko
    #    /lib/modules/5.4.72-v7l+/updates/88XXau.ko
    #
    ### method 3
    #
}
#
#
######################### RTL8821CU fars robotics (3)  #########################
#
function install_rtl8821cu_fars(){
    echo "***** install RTL8821CU from FARS-ROBOTICS ******"
    echo
    get_fars_robotics
    sudo install-wifi 8821cu
}
#
#
######################### RTL8814AU fars robotics (4) ##########################
#
function install_rtl8814au_fars(){
    echo "***** install RTL8814AU (RTL8812AU) from FARS-ROBOTICS ******"    
    echo
    get_fars_robotics
    sudo install-wifi 8812au
}
#
#
################################################################################
#########################  START DRIVER INSTALLATION  ##########################
################################################################################
#
go=true
start=true
#
while $go
do
    ask
    if $start && [ ! "$drivers" == 5 ]
    then
        install_requirements
        create_wifi_directory
        start=false
    fi
    #
    case $drivers in
        1)
        install_rtl8821cu_brkt
        ;;
        2)
        echo "Not working currently"
        #install_rtl8814au_rcrg
        ;;
        3)
        install_rtl8821cu_fars
        ;;
        4)
        install_rtl8814au_fars
        ;;
        5)
        echo "Finish installing drivers"
        go=false
        ;;
    esac
done
#
#
exit 0
