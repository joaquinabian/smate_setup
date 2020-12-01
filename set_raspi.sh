#!/bin/bash
#
#
############################### SET SPANISH KEYBOARD ##############################
TARGET="/etc/default/keyboard"
echo "Setting Spanish keyboard at $TARGET"
#
cat > $TARGET <<- EOF
# generated by smate setup script
XKBMODEL=pc105
XKBLAYOUT=es
XKBVARIANT=es
XKBOPTIONS=
BACKSPACE=guess
EOF
#
#
################################ SET US LOCALE  ###################################
TARGET="/etc/default/locale"
echo "Setting US locale at $TARGET"
#
cat > $TARGET <<- EOF
# generated by smate setup script
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8
EOF
#
#
############################### SET MADRID TIMEZONE #################################
echo "Setting Madrid Timezone"
#
sudo timedatectl set-timezone Europe/Madrid
#
#
###############################  SET WIFI COUNTRY  #################################
# this is not permanently set on raspi when using raspi-config
# raspi-config does not modify /etc/default/crda
# my raspi 4 seems to work OK without this setting
# see https://www.raspberrypi.org/forums/viewtopic.php?t=260974
# sudo iw reg set ES
#
#
############################  SET SCREEN RESOLUTION ###############################
# 1920x1080 60Hz 1080p-> group 2, mode 82   
# https://www.raspberrypi.org/documentation/configuration/config-txt/video.md
TARGET="/boot/config.txt"
echo "Seting screen resolution to 1920x1080"
#
# -i    -> case insensitive
#  s    -> substitute
#  ^    -> start of line
#  \#\? -> zero or one '#'
#  .\?  -> zero or one character (to catch a space after '#')
#  .*$  -> any number of chars before end-of-line
#  g -> greedy
sed -i "s/^\#\?.\?hdmi_group:0=.*$/hdmi_group:0=2/g" $TARGET
sed -i "s/^\#\?.\?hdmi_mode:0=.*$/hdmi_mode:0=82/g" $TARGET
#
#
###################################################################################
