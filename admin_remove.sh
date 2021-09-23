#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

COMMAND="lsblk -J -o NAME,FSTYPE,SIZE,MOUNTPOINT,TYPE,LABEL" 
MOUNT="/mnt/WinPart" 

function error_message (){
	printf $RED"Error:$NC $1\n" >&2
}

#check if script is being run as root
if [[ $EUID -ne 0 ]]
then
   error_message "This script must be run as root" 
   exit 1;
fi

#check number of arguments 
if (($# != 1))
then 
	error_message "Name of the user is$RED required $NC "
	exit 2;

else
	USER=$1
	USER_DIR="$MOUNT/Users/"
	USER_FOLDER="$MOUNT/Users/$USER"
	DIR="$MOUNT/Windows/System32/config"

	printf 	"Number of Arguments$GREEN OK! $NC \n\n"
	# printf  "User$BLUE $USER $NC\n"	
fi

#get the list of all partitions and pass it to python
echo "Locating Windows Partition"
DISK=$(python3 partition_parse.py "$($COMMAND)")

#if the number of disks is more than 1
if (($(echo $DISK | wc -w) != 1))
then 
	error_message "Too many disks of size G found"
	exit 3;
fi

printf "Partition$GREEN Located $NC\n"

#create mountpoint
sudo mkdir -p $MOUNT

#mount partition
sudo mount -t auto -v /dev/$DISK $MOUNT
printf "Partition$GREEN mounted$NC\n\n" 

printf "Enabling universe repo\n"

#enable universe repo
sudo add-apt-repository universe &> /dev/null;
sudo apt update &> /dev/null;
printf $GREEN"Enabled$NC\n\n"

printf "Installing$BLUE chntpw$NC\n"
#install chntpw
sudo apt install --yes chntpw &> /dev/null;
printf $GREEN"Installed$NC\n\n"

#verify if folder with supplied username exists
printf "Verifying user exists on Windows Partition\n"
if [ ! -d "$USER_FOLDER" ]; then
	error_message "User not found\n"

	#cd to user dir
	cd $USER_DIR;
	printf "Users found:\n$BLUE$(ls -d */)$NC\n"

	sudo umount /dev/$DISK -l
	exit 4;
fi

printf "User$BLUE $USER$NC exists\n"

if [ ! -e "$DIR/SAM" ]; then
	error_message "SAM file$RED NOT FOUND!$NC"

	sudo umount /dev/$DISK -l
	exit 5;
fi

cd $DIR;
printf "SAM file$GREEN exists$NC\n\n";

printf "Running$BLUE chntpw$NC with user$BLUE $USER$NC\n\n"; 
chntpw -i $USER SAM;

#unmount partition
sudo umount /dev/$DISK -l;

#countdown reboot
sec=10
while [ $sec -ge 0 ]; do
	echo -ne "Reboot in$GREEN $sec\033[0K\r$NC"
	let "sec=sec-1"
	sleep 1;
done

sudo reboot;




