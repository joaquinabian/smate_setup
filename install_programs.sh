#!/bin/bash
#
# 
echo "Install Geany"
sudo apt install geany
#
echo "Install Simple Screen Recorder"
sudo apt install simplescreenrecorder
#
echo "install lshw"
sudo apt install lshw
#
echo "install usbview"
sudo apt install usbview
#
echo "install sysinfo"
sudo apt install sysinfo
#
echo "install hardinfo"
sudo apt install hardinfo
#
####################################  WAVEMON  #####################################################
echo "Install wavemon"
sudo apt install wavemon
#
TARGET="~/.wavemonrc"
cat > $TARGET <<- EOF
interface = wlan0
cisco_mac = off
sort_order = chan/sig
sort_ascending = off
stat_updates = 100
lhist_slot_size = 10
meter_smoothness = 0
info_updates = 10
override_auto_scale = on
min_signal_level = -50
max_signal_level = -30
min_noise_level = -120
max_noise_level = -40
lo_threshold_action = disabled
hi_threshold_action = disabled
startup_screen = info screen
EOF
#
sudo setcap cap_net_admin=eip /usr/bin/wavemon
#
###################################### TELNET ####################################################
echo "Install TELNET"
sudo apt install telnet
#
