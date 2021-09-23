#!/usr/bin/env bash

CLONE_DIR="admin_script_tis" 

if [ -d $CLONE_DIR ] ;
then
#remove the directory and reclone
   rm $CLONE_DIR 
   printf "Folder already existed and has been removed\n" 
fi

git clone https://github.com/agulam-coco/admin_script_tis.git

cd $CLONE_DIR
./admin_remove.sh "$@"	
