#!/bin/bash
#
# This file is called from /etc/xdg/autostart/smate_slave_boot.desktop
#
cd /home/stellarmate/Documents
#
./rpi_camera_surveillance_system.py >> /home/stellarmate/Desktop/camera_log.txt 2>&1 &
echo "Camera ON"
#
gpspipe -w | ./gpsfix.py
echo "GPS ON"
#
sudo service chrony start
echo "CHRONY ON"
#
indiserver -v indi_gpsd >> /home/stellarmate/Desktop/indi_log.txt 2>&1 &
#indiserver -v indi_gpsd | tee /home/stellarmate/Desktop/indi_log.txt
echo "indiserving GPSD"
#
echo 'done'
