#!/bin/bash
#
# 
##########################   SET DESKTOP FOLDERS FOR INDI & KSTARS LOGS    #########################
# Make two soft links on the desktop to Logs folders
echo "create links to logs"
ln -s /home/stellarmate/.indi/logs /home/stellarmate/Desktop/indi_logs
ln -s /home/stellarmate/.local/share/kstars/logs /home/stellarmate/Desktop/kstars_logs
echo "done"
#
################################  REMOVE NOT USED FOLDERS   ########################################
# I use 'rmdir' instead of 'rm -r' because if there is something inside it will fail
# remove subfolders first, then main folder 
echo "remove .astropy folder"
rmdir /home/stellarmate/.astropy/config
rmdir /home/stellarmate/.astropy
echo "done"
#
echo "remove astropy link"
rm /home/stellarmate/.config/astropy || echo "astropy link cannot be removed"
echo "done"
################################   CHANGE NAME OF MACHINE    #######################################
# to master, slave o test:
#     stellarmate@master
# sudo nano /etc/hosts
#   - replace '127.0.1.1\traspberry' with '127.0.1.1\t<name>'
# sudo nano /etc/hostname
#   - set <name>
#
echo "change raspi name to stellarmate@$RPITYPE"
echo "to be done"
############################   DONT START KSTARS AT BOOT  ##########################################
echo "Do not start KStars at boot"
TARGET="/home/stellarmate/.config/autostart/KStars.desktop"
text="NotShowIn=LXDE;"
echo $text >> $TARGET
echo "done"
####################################################################################################

