#!/bin/bash
#
# 
TARGET="/etc/default/rpi-eeprom-update"
echo "Update EEPROM to allow boot from SSD"
#
# -i    -> case insensitive
#  s    -> substitute
#  ^    -> start of line
#  \#\? -> zero or one '#'
#  .\?  -> zero or one character (to catch a space after '#')
#  .*$  -> any number of chars before end-of-line
#  g -> greedy
sed -i "s/^\#\?.\?FIRMWARE_RELEASE_STATUS=.*$/FIRMWARE_RELEASE_STATUS=\"stable\"/g" $TARGET
sudo rpi-eeprom-update -d -a
sync
echo "Please Reboot to activate changes"
echo "After reboot check that <vcgencmd bootloader_version> returns version older than June 15, 2020"
echo "Then copy SD card to SSD  with 'SD card copier'"
echo "Then shutdown and remove SD card"

