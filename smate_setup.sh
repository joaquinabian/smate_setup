#!/bin/bash
# Main function
# Calls diferent scripts for setting-up and customize a Stellarmate distribution
#
#
function execute_shell
{
    echo
    echo "##-----------------------------------------##"
    echo "$1"
    echo "##-----------------------------------------##"
    #
    ./"$2" || exit 1
    #
    echo
    echo "** $2 DONE **"
    echo
}
#
#
# Check it is running as root
#
if [ "$(whoami)" != "root" ]
then
    echo "This script must be run with root privileges (sudo)."
    echo "Try again."
    exit 0
fi
#
#
echo
echo "*****  DEFINE RASPI MASTER/SLAVE *******"
echo
#
message=$(cat <<- EOF
Is this raspberry pi a
   - Master (.211)
   - Slave  (.212)
   - Test   (.215)
   ¿ M / S / T ?  default T -> 
EOF
)
#
read -r -p "$message" input
#
input=${input:-"t"}
input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
#
if [ "$input" = "m" ]
then
    RPITYPE="master"
elif [ "$input" = "s" ]
then
    RPITYPE="slave"
else
    RPITYPE="test"
fi
#
echo
echo "*****  GET ROUTER HOME ROUTER PASSWORD *******"
echo
#
read -r -p "Wifi router password ?" PASSWRD
#
#
export RPITYPE
export PASSWRD
#
#
#
echo
echo "******  GET INTERNET FIRST  ******"
TEXT="set wifi connections (home network)"
SCRIPT="set_wifi_home.sh"
execute_shell "$TEXT" "$SCRIPT"
#
echo
echo "*****  SETTING SYSTEM UP-TO-DATE   ******"
sudo apt -y update
sudo apt -y upgrade
#
#
#############################  START CONFIGURATIONS  ###########################
#
TEXT="configuring keyboard, locale, timezone and screen resolution"
SCRIPT="set_raspi.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="installing useful programs"
SCRIPT="install_programs.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="set wifi connections (tplink)"
SCRIPT="set_wifi_tplink.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="SET BOOT FROM SSD"
SCRIPT="set_ssd.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="install external wifi adapters"
SCRIPT="install_wifi_adapters.sh"
execute_shell "$TEXT" "$SCRIPT"
#
if [ "$RPITYPE" = "slave" ]
then
    TEXT="install GPS AND CAMERA"
    SCRIPT="set_slave_camera_gps.sh"
    execute_shell "$TEXT" "$SCRIPT"
fi
#
TEXT="setting up stellarmate things"
SCRIPT="set_smate.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
echo "****** FINISHED ********"
echo "**** PLEASE REBOOT *****"
