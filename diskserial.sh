#!/bin/bash
# Copyright 2019 Matt Wisnowski
# The purpose of this script was to check the serial number of drives in a "generic" linux-based NAS unit
# It's a bit of a mess as I didn't have a lot of experience writing bash scripts of this scope
# I'mhonestly  still not too confident on how best to truncate it
DS=/tmp/diskserial.txt
if [[ "$1" == "--check" ]]; then
if [[ "$2" == "-2" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-7" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 1\e[0m" >> $DS. smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-4" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
#!
elif [[ "$2" == "-9" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 1\e[0m" >> $DS. smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34m Exp 1 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-5" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-10" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdha|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdhb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdhc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdhd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdhe|grep Serial|sed 's/Serial\ Number\:\ *//' >> /$DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-15" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdha|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdhb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdhc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdhd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdhe|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-8" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-13" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"echo -e "\e[1;34mExpansion 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdia|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdib|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdic|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdid|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdie|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdieserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdja|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdjb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdjc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdjd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdje|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjeserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-18" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgeserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdha|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdhb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdhc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdhd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdhe|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdheserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-12" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-24" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdma|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdmb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdmc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdna|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdnb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdnc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdoa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdob|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdoc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdpa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdpb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-36" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdma|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdmb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdmc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdna|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdnb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdnc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdoa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdob|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdoc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdpa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdpb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion Disk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqa1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdqa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdqb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdqc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdra1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdra|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdra1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdrb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdrc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdra1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdra|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdrb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrc1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 9\e[0m" >> $DS; smartctl --all -d ata /dev/sdrc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsa1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 10\e[0m" >> $DS; smartctl --all -d ata /dev/sdsa|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsb1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 11\e[0m" >> $DS; smartctl --all -d ata /dev/sdsb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 12\e[0m" >> $DS; smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
			-2 : For use on most 2-bay units with no expansion uni
			-7 : For use on most 2-bay units with 1 expansion unit
			-4 : For use on most 4-bay units with no expansion unit
			-9 : For use on most 4-bay units with 1 5-bay expansion unit
			-5 : For use on most 5-bay units with no expansion unit
			-10 : For use on most 5-bay units with 1 5-bay expansion unit
			-15 : For use on most 5-bay units with 2 5-bay expansion units
			-8 : For use on most 8-bay units with no expansion unit
			-13 : For use on most 8-bay units with 1 5-bay expansion unit
			-18 : For use on most 8-bay units with 2 5-bay expansion units
			-12 : For use on most 12-bay units with no expansion units
			-24 : For use on most 12-bay units with 1 12-bay expansion unit
			-36 : For use on most 12-bay units with 2 12-bay expansion units
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See help section.";
fi
elif [[ "$1" == "--parse" ]]; then
if [[ "$2" == "-2" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

elif [[ "$2" == "-7" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgaserial.txt;
		grep -rf /tmp/sdgaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgbserial.txt;
		grep -rf /tmp/sdgbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgcserial.txt;
		grep -rf /tmp/sdgcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgdserial.txt;
		grep -rf /tmp/sdgdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgeserial.txt;
		grep -rf /tmp/sdgeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

elif [[ "$2" == "-4" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

elif [[ "$2" == "-9" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgaserial.txt;
		grep -rf /tmp/sdgaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgbserial.txt;
		grep -rf /tmp/sdgbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgcserial.txt;
		grep -rf /tmp/sdgcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgdserial.txt;
		grep -rf /tmp/sdgdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgeserial.txt;
		grep -rf /tmp/sdgeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks or connected expansion unit\e[0m"
		fi

elif [[ "$2" == "-5" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

elif [[ "$2" == "-10" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgaserial.txt;
		grep -rf /tmp/sdgaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgbserial.txt;
		grep -rf /tmp/sdgbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgcserial.txt;
		grep -rf /tmp/sdgcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgdserial.txt;
		grep -rf /tmp/sdgdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgeserial.txt;
		grep -rf /tmp/sdgeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 1 ]
	then smartctl --all -d ata /dev/sdha|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhaserial.txt;
		grep -rf /tmp/sdhaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 1 ]
	then smartctl --all -d ata /dev/sdhb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhbserial.txt;
		grep -rf /tmp/sdhbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 1 ]
	then smartctl --all -d ata /dev/sdhc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhcserial.txt;
		grep -rf /tmp/sdhcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 1 ]
	then smartctl --all -d ata /dev/sdhd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhdserial.txt;
		grep -rf /tmp/sdhdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 1 ]
	then smartctl --all -d ata /dev/sdhe|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdheserial.txt;
		grep -rf /tmp/sdheserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

elif [[ "$2" == "-15" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 1 ]
	then smartctl --all -d ata /dev/sdga|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgaserial.txt;
		grep -rf /tmp/sdgaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 1 ]
	then smartctl --all -d ata /dev/sdgb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgbserial.txt;
		grep -rf /tmp/sdgbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 1 ]
	then smartctl --all -d ata /dev/sdgc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgcserial.txt;
		grep -rf /tmp/sdgcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 1 ]
	then smartctl --all -d ata /dev/sdgd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgdserial.txt;
		grep -rf /tmp/sdgdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 1 ]
	then smartctl --all -d ata /dev/sdge|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgeserial.txt;
		grep -rf /tmp/sdgeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 1 ]
	then smartctl --all -d ata /dev/sdha|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhaserial.txt;
		grep -rf /tmp/sdhaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 1 ]
	then smartctl --all -d ata /dev/sdhb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhbserial.txt;
		grep -rf /tmp/sdhbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 1 ]
	then smartctl --all -d ata /dev/sdhc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhcserial.txt;
		grep -rf /tmp/sdhcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 1 ]
	then smartctl --all -d ata /dev/sdhd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhdserial.txt;
		grep -rf /tmp/sdhdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 1 ]
	then smartctl --all -d ata /dev/sdhe|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdheserial.txt;
		grep -rf /tmp/sdheserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

elif [[ "$2" == "-8" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdfserial.txt;
		grep -rf /tmp/sdfserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgserial.txt;
		grep -rf /tmp/sdgserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhserial.txt;
		grep -rf /tmp/sdhserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

elif [[ "$2" == "-13" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdfserial.txt;
		grep -rf /tmp/sdfserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgserial.txt;
		grep -rf /tmp/sdgserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhserial.txt;
		grep -rf /tmp/sdhserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 1 ]
	then smartctl --all -d ata /dev/sdia|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdiaserial.txt;
		grep -rf /tmp/sdiaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 1 ]
	then smartctl --all -d ata /dev/sdib|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdibserial.txt;
		grep -rf /tmp/sdibserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 1 ]
	then smartctl --all -d ata /dev/sdic|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdicserial.txt;
		grep -rf /tmp/sdicserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 1 ]
	then smartctl --all -d ata /dev/sdid|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdidserial.txt;
		grep -rf /tmp/sdidserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 1 ]
	then smartctl --all -d ata /dev/sdie|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdieserial.txt;
		grep -rf /tmp/sdieserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 1 ]
	then smartctl --all -d ata /dev/sdja|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjaserial.txt;
		grep -rf /tmp/sdjaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 1 ]
	then smartctl --all -d ata /dev/sdjb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjbserial.txt;
		grep -rf /tmp/sdjbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 1 ]
	then smartctl --all -d ata /dev/sdjc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjcserial.txt;
		grep -rf /tmp/sdjcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 1 ]
	then smartctl --all -d ata /dev/sdjd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjdserial.txt;
		grep -rf /tmp/sdjdserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 1 ]
	then smartctl --all -d ata /dev/sdje|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjeserial.txt;
		grep -rf /tmp/sdjeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

elif [[ "$2" == "-18" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 6\e[0m" >> $DS; smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 7\e[0m" >> $DS; smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then  echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mDisk 8\e[0m" >> $DS; smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"echo -e "\e[1;34mExpansion 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdia|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdib|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdic|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdid|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion1 Disk 1 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdie|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdieserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 1\e[0m" >> $DS; smartctl --all -d ata /dev/sdja|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 2\e[0m" >> $DS; smartctl --all -d ata /dev/sdjb|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 3\e[0m" >> $DS; smartctl --all -d ata /dev/sdjc|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 4\e[0m" >> $DS; smartctl --all -d ata /dev/sdjd|grep Serial|sed 's/Serial\ Number\:\ *//' >> $DS;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34mExpansion 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 1 ]
	then echo -e "\e[1;32mDisk found\e[0m"; echo -e "\e[1;34mExpansion 2 Disk 5\e[0m" >> $DS; smartctl --all -d ata /dev/sdje|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjeserial.txt;
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-12" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdfserial.txt;
		grep -rf /tmp/sdfserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgserial.txt;
		grep -rf /tmp/sdgserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhserial.txt;
		grep -rf /tmp/sdhserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdiserial.txt;
		grep -rf /tmp/sdiserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjserial.txt;
		grep -rf /tmp/sdjserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdkserial.txt;
		grep -rf /tmp/sdkserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdlserial.txt;
		grep -rf /tmp/sdlserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
cat $DS
#!
elif [[ "$2" == "-24" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdfserial.txt;
		grep -rf /tmp/sdfserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgserial.txt;
		grep -rf /tmp/sdgserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhserial.txt;
		grep -rf /tmp/sdhserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdiserial.txt;
		grep -rf /tmp/sdiserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjserial.txt;
		grep -rf /tmp/sdjserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdkserial.txt;
		grep -rf /tmp/sdkserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdlserial.txt;
		grep -rf /tmp/sdlserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 1 ]
	then smartctl --all -d ata /dev/sdma|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmaserial.txt;
		grep -rf /tmp/sdmaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 1 ]
	then smartctl --all -d ata /dev/sdmb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmbserial.txt;
		grep -rf /tmp/sdmbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 1 ]
	then smartctl --all -d ata /dev/sdmc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmcserial.txt;
		grep -rf /tmp/sdmcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 1 ]
	then smartctl --all -d ata /dev/sdna|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdnaserial.txt;
		grep -rf /tmp/sdnaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 1 ]
	then smartctl --all -d ata /dev/sdnb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdnbserial.txt;
		grep -rf /tmp/sdnbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 1 ]
	then smartctl --all -d ata /dev/sdnc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdncserial.txt;
		grep -rf /tmp/sdncserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 1 ]
	then smartctl --all -d ata /dev/sdoa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdoaserial.txt;
		grep -rf /tmp/sdoaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 1 ]
	then smartctl --all -d ata /dev/sdob|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdobserial.txt;
		grep -rf /tmp/sdobserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 1 ]
	then smartctl --all -d ata /dev/sdoc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdocserial.txt;
		grep -rf /tmp/sdocserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 1 ]
	then smartctl --all -d ata /dev/sdpa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpaserial.txt;
		grep -rf /tmp/sdpaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 1 ]
	then smartctl --all -d ata /dev/sdpb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpbserial.txt;
		grep -rf /tmp/sdpbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpc1` == 1 ]
	then smartctl --all -d ata /dev/sdpc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpcserial.txt;
		grep -rf /tmp/sdpcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi
elif [[ "$2" == "-36" ]]; then
rm /tmp/sd*serial.txt;
echo -e "\e[1;34mDisk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 1 ]
	then smartctl --all -d ata /dev/sda|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdaserial.txt;
		grep -rf /tmp/sdaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sda1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 1 ]
	then smartctl --all -d ata /dev/sdb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdbserial.txt;
		grep -rf /tmp/sdbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi
echo "----"
echo -e "\e[1;34mDisk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 1 ]
	then smartctl --all -d ata /dev/sdc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdcserial.txt;
		grep -rf /tmp/sdcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 1 ]
	then smartctl --all -d ata /dev/sdd|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sddserial.txt;
		grep -rf /tmp/sddserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 1 ]
	then smartctl --all -d ata /dev/sde|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdeserial.txt;
		grep -rf /tmp/sdeserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sde1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 1 ]
	then smartctl --all -d ata /dev/sdf|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdfserial.txt;
		grep -rf /tmp/sdfserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 1 ]
	then smartctl --all -d ata /dev/sdg|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdgserial.txt;
		grep -rf /tmp/sdgserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 1 ]
	then smartctl --all -d ata /dev/sdh|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdhserial.txt;
		grep -rf /tmp/sdhserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 1 ]
	then smartctl --all -d ata /dev/sdi|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdiserial.txt;
		grep -rf /tmp/sdiserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdi1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 1 ]
	then smartctl --all -d ata /dev/sdj|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdjserial.txt;
		grep -rf /tmp/sdjserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdj1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 1 ]
	then smartctl --all -d ata /dev/sdk|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdkserial.txt;
		grep -rf /tmp/sdkserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdk1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34mDisk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 1 ]
	then smartctl --all -d ata /dev/sdl|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdlserial.txt;
		grep -rf /tmp/sdlserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdl1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 1 ]
	then smartctl --all -d ata /dev/sdma|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmaserial.txt;
		grep -rf /tmp/sdmaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdma1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 1 ]
	then smartctl --all -d ata /dev/sdmb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmbserial.txt;
		grep -rf /tmp/sdmbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 1 ]
	then smartctl --all -d ata /dev/sdmc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdmcserial.txt;
		grep -rf /tmp/sdmcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdmc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 1 ]
	then smartctl --all -d ata /dev/sdna|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdnaserial.txt;
		grep -rf /tmp/sdnaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdna1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 1 ]
	then smartctl --all -d ata /dev/sdnb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdnbserial.txt;
		grep -rf /tmp/sdnbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 1 ]
	then smartctl --all -d ata /dev/sdnc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdncserial.txt;
		grep -rf /tmp/sdncserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdnc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 1 ]
	then smartctl --all -d ata /dev/sdoa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdoaserial.txt;
		grep -rf /tmp/sdoaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 1 ]
	then smartctl --all -d ata /dev/sdob|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdobserial.txt;
		grep -rf /tmp/sdobserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdob1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 1 ]
	then smartctl --all -d ata /dev/sdoc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdocserial.txt;
		grep -rf /tmp/sdocserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdoc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 1 ]
	then smartctl --all -d ata /dev/sdpa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpaserial.txt;
		grep -rf /tmp/sdpaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 1 ]
	then smartctl --all -d ata /dev/sdpb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpbserial.txt;
		grep -rf /tmp/sdpbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 1 Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpc1` == 1 ]
	then smartctl --all -d ata /dev/sdpc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdpcserial.txt;
		grep -rf /tmp/sdpcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdpc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 1\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqa1` == 1 ]
	then smartctl --all -d ata /dev/sdqa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdqaserial.txt;
		grep -rf /tmp/sdqaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 2\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqb1` == 1 ]
	then smartctl --all -d ata /dev/sdqb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdqbserial.txt;
		grep -rf /tmp/sdqbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 3\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqc1` == 1 ]
	then smartctl --all -d ata /dev/sdqc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdqcserial.txt;
		grep -rf /tmp/sdqcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdqc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 4\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdra1` == 1 ]
	then smartctl --all -d ata /dev/sdra|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdraserial.txt;
		grep -rf /tmp/sdraserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdra1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 5\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 1 ]
	then smartctl --all -d ata /dev/sdrb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdrbserial.txt;
		grep -rf /tmp/sdrbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 6\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrc1` == 1 ]
	then smartctl --all -d ata /dev/sdrc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdrcserial.txt;
		grep -rf /tmp/sdrcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdrc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 7\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsa1` == 1 ]
	then smartctl --all -d ata /dev/sdsa|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdsaserial.txt;
		grep -rf /tmp/sdsaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsa1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 8\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsb1` == 1 ]
	then smartctl --all -d ata /dev/sdsb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdsbserial.txt;
		grep -rf /tmp/sdsbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 9\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsc1` == 1 ]
	then smartctl --all -d ata /dev/sdsc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdscserial.txt;
		grep -rf /tmp/sdscserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdsc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 10\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdta1` == 1 ]
	then smartctl --all -d ata /dev/sdta|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdtaserial.txt;
		grep -rf /tmp/sdtaserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdta1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 11\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdtb1` == 1 ]
	then smartctl --all -d ata /dev/sdtb|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdtbserial.txt;
		grep -rf /tmp/sdtbserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdtb1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

echo "----"
echo -e "\e[1;34m Exp 2 Disk 12\e[0m"
if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdtc1` == 1 ]
	then smartctl --all -d ata /dev/sdtc|grep Serial|sed 's/Serial\ Number\:\ *//' >> /tmp/sdtcserial.txt;
		grep -rf /tmp/sdtcserial.txt /etc/space|sort -r|head -n8
	elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdtc1` == 0 ]
		then echo -e "\e[1;31mNo disk found, please try manual checks \e[1;34mor other expansion unit\e[0m"
		fi

elif [[ "$2" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
			-2 : For use on most 2-bay units with no expansion uni
			-7 : For use on most 2-bay units with 1 expansion unit
			-4 : For use on most 4-bay units with no expansion unit
			-9 : For use on most 4-bay units with 1 5-bay expansion unit
			-5 : For use on most 5-bay units with no expansion unit
			-10 : For use on most 5-bay units with 1 5-bay expansion unit
			-15 : For use on most 5-bay units with 2 5-bay expansion units
			-8 : For use on most 8-bay units with no expansion unit
			-13 : For use on most 8-bay units with 1 5-bay expansion unit
			-18 : For use on most 8-bay units with 2 5-bay expansion units
			-12 : For use on most 12-bay units with no expansion units
			-24 : For use on most 12-bay units with 1 12-bay expansion unit
			-36 : For use on most 12-bay units with 2 12-bay expansion units
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See help section.";
fi
elif [[ "$1" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
			--check : Will check the serial numbers of all detected disks based on the secondary run mode
			--parse : Will check the serial numbers of all detected disks and parse the last 8 space files (if they exist) that serial number is detected in
			";
else
    echo "Invalid argument. See help section.";
fi
