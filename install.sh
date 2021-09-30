#!/usr/bin/env bash

CLONE_DIR="admin_script_tis" 

BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

function error_message (){
	printf $RED"Error:$NC $1\n" >&2
}

#check if script is being run as root
if [[ $EUID -ne 0 ]]
then
   error_message "This script must be run as root" 
   exit 1;
fi

#install needed dependencies
sudo apt install --yes git

if [ -d $CLONE_DIR ] ;
then
#remove the directory and reclone
   rm -rf $CLONE_DIR 
   printf $BLUE"Folder already existed and has been removed\n$NC" 
fi

git clone https://github.com/agulam-coco/admin_script_tis.git

cd $CLONE_DIR
sudo ./admin_remove.sh "$@"	
