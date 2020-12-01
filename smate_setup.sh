#!/bin/bash
#
#
# Check it is running as root
#
if [ "$(whoami)" != "root" ]
then
    echo "This script must be run with root privileges (sudo)."  
    echo "Try again."
    exit 1
fi
#
#
function execute_shell
{
echo " "    
echo "##-----------------------------------------##"
echo "$1"
echo "##-----------------------------------------##"
#nmcl
./$2 || exit 1
#
echo "$2 DONE"
echo " "    
}
#
echo " "
echo "*****  SETTING SYSTEM UP-TO-DATE   ******"
sudo apt -y update
sudo apt -y upgrade
#
TEXT="configuring keyboard, locale, timezone and screen resolution"
SCRIPT="config_raspi.sh"
#execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="set wifi connections (home network)"
SCRIPT="set_wifi_home.sh"
#execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="set wifi connections (tplink)"
SCRIPT="set_wifi_tplink.sh"
#execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="SET BOOT FROM SSD"
SCRIPT="set_ssd.sh"
#execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="install external wifi adapters"
SCRIPT="install_wifi_adapters.sh"
execute_shell "$TEXT" "$SCRIPT"
#
#
TEXT="installing useful programs"
SCRIPT="install_programs.sh"
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
