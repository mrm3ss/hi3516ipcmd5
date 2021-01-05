#!/bin/bash
##===============================================================
##
## USAGE: 
##    pwgen.sh password
##
## DESCRIPTION:
##    Hisilicon 3516 based IPC md5 password hash generation
##   
## IMPLEMENTATION
##    version         1.0.0.1
##    author          Ivan Stimac
##    copyright       Copyright (c) http://www.invizum.com
##    license         GNU General Public License
##
##===============================================================


if [ $# -gt 0 ] && ( [ $1 == "-h" ] || [ $1 == "--help" ] ); then

	printf "Usage: pwgen.sh password\n"
	exit

fi



pwd=$1

pwdMd5=$(echo -n $pwd | md5sum | awk '{print $1}')

ipcHash=""



declare -i byteL
declare -i byteH

for  (( i =0; i<8; i++ ))
do

	byteL=0x${pwdMd5:i*4:2}
	byteH=0x${pwdMd5:(i*4)+2:2}

	
	declare -i x=$(($byteL+$byteH))
	declare -i xMod=$(($x%0x3e))
	
		
	if (($xMod < 0x09)); then 
		xMod=$(($xMod + 0x30))
	elif (($xMod >= 0x09 && $xMod < 0x0a)); then
		xMod=$(($xMod + 0x3d))
	elif (($xMod >= 0x0a && $xMod < 0x23)); then
		xMod=$(($xMod + 0x37))
	elif (($xMod >= 0x0a && $xMod >= 0x23)); then
		xMod=$(($xMod + 0x3d))
	fi
	
	
	ipcHash+=$(printf "\x$(printf %x $xMod)")
done


# echo the result
printf "Plain password: %s\n" $pwd
printf "Md5Sum: %s\n" $pwdMd5
printf "Encripted ipc hash: %s\n" $ipcHash


