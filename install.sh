#!/usr/bin/env bash

CLONE_DIR="admin_script_tis" 

#check if script is being run as root
if [[ $EUID -ne 0 ]]
then
   error_message "This script must be run as root" 
   exit 1;
fi

#install needed dependencies
sudo apt install --yes curl git

if [ -d $CLONE_DIR ] ;
then
#remove the directory and reclone
   rm -rf $CLONE_DIR 
   printf "Folder already existed and has been removed\n" 
fi

git clone https://github.com/agulam-coco/admin_script_tis.git

cd $CLONE_DIR
sudo ./admin_remove.sh "$@"	
