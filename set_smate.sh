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
##############################    ######################

