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
    echo "$2 DONE"
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
#
text="Is this raspberry pi a\n"
text+="- Master (.211)\n"
text+="- Slave  (.212)\n"
text+="- Test   (.215)\n"
text+=" ¿ M / S / T ?  default T -> "
read -r -p "$text" input
#
input=${input:-"t"}
input=$(echo "$input" | tr '[:lower:]' '[:upper:]')
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
export RPITYPE
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
#################################    START CONFIGURATIONS    #######################################
#
TEXT="configuring keyboard, locale, timezone and screen resolution"
SCRIPT="config_raspi.sh"
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
#
TEXT="setting up stellarmate things"
SCRIPT="set_smate.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
echo "****** FINISHED ********"
echo "**** PLEASE REBOOT *****"
