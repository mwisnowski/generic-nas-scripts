sda5#! /bin/bash
# Created by Matthew Wisnowski sometime in 2017, modified June 27th, 2019.
# The purpose of this script was to create a training environment for potential RAID/data recovery scenarios.
# The values used are specific to this script as it would help create a consistent environment.
# Disk locations can be changed if needed, but are as follows by default
# lvm-based: sda5, sdb5, sdc5
# non-lvm-based: sdd3, sde3, sdf3
MD2=/dev/md2
MD3=/dev/md3
MDSTAT=/proc/mdstat

# Fixing mode
# lvm
echo -e "\e[0;31mDO NOT RUN IN A PRODUCTION ENVIRONMENT. MATT WISNOWSKI MAY NOT BE HELD RESPONSIBLE FOR NEGLIGENT DATA LOSS\e[0m"
if [[ "$1" == "--fixer" ]]; then
if [[ "$2" == "--lvm" ]]; then
echo -e "\e[1;34mAttempting to fix lvm array and mount volume\e[0m"
echo -e "\e[1;34mAssembling md2\e[0m"
if [ `grep -c /dev/md2 /proc/mdstat` == 0 ]
		then mdadm -S /dev/md2 &> /dev/null; mdadm -Af /dev/md2 /dev/sdc5 /dev/sd[bc]5 &> /dev/null
		elif [ `grep -c "md2 : active" /proc/mdstat` == 1 ]
		then mdadm -S /dev/md2 &> /dev/null; mdadm -Af /dev/md2 /dev/sdc5 /dev/sd[bc]5 &> /dev/null
		echo -e "\e[1;32mmd2 active\e[0m"
		else echo -d "\e[1;31mmd2 either assembled properly or needs further investigation\e[0m"
	fi
cat /proc/mdstat
echo -e "\e[1;34mActivating vg1\e[0m"
	if [ `pvs|grep -c md2` == 1 ] && [ `lvm lvscan|grep -c ACTIVE` == 0 ]
		then vgchange -ay vg1 &> /dev/null
		echo -e "\e[1;32mvg1 active\e[0m"
		else echo -e "\e[1;31mEither the md is not assembled or vg already active\e[0m"
	fi
lvm lvscan
echo -e "\e[1;34mMounting volume1\e[0m"
	if [ `lvm lvscan|grep -c ACTIVE` == 2 ] && [ `mount|grep -c /volume1` == 0 ]
		then mount /dev/vg1/volume_1 /volume1
	fi
echo -e "\e[1;34mChecking mount\e[0m"
	if [ `mount|grep -c /volume1` == 1 ]
		then echo -e "\e[1;32mvolume1 working and mounted\e[0m"
		else echo -e "\e[1;31mvolume 1 not mounted\e[0m"
	fi
mount|grep /volume1

# non-lvm
elif [[ "$2" == "--non-lvm" ]]; then
echo -e "\e[1;34mAttempting to fix non-lvm RAID array and mount volume\e[0m"
echo -e "\e[1;34mAssembling md3\e[0m"
if [ `grep -c /dev/md3 /proc/mdstat` == 0 ]
		then mdadm -S /dev/md3 &> /dev/null; mdadm -Af /dev/md3 /dev/sd[def]3 &> /dev/null
		elif [ `grep -c "md3 : active" /proc/mdstat` == 1 ]
		then mdadm -S /dev/md3 &> /dev/null; mdadm -Af /dev/md3 /dev/sd[def]3 &> /dev/null
		echo -e "\e[1;32mmd3 active\e[0m"
		else echo -d "\e[1;31mmd3 either assembled properly or needs further investigation\e[0m"
	fi
cat /proc/mdstat
echo -e "\e[1;34mMounting volume2\e[0m"
	if [ `grep -c "md3 : active" /proc/mdstat` == 1 ] && [ `mount|grep -c /volume2` == 0 ]
		then mount /dev/md3 /volume2
		echo -e "\e[1;32mMount successful\e[0m"
	fi
echo -e "\e[1;34mChecking mount\e[0m"
	if [ `mount|grep -c /volume2` == 1 ]
		then echo -e "\e[1;32mvolume2 working and mounted\e[0m"
		else echo -e "\e[1;31mvolume 2 not mounted\e[0m"
	fi
mount|grep /volume2

# Help
elif [[ "$2" == "--help" ]]; then
	echo "Usage:
                    --lvm : fix and mount lvm RAID array and ext4 volume
                    --non-lvm : fix and mount non-lvm RAID array and ext4 volume
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo -e "\e[1;31mInvalid argument. See --help section.\e[0m";
fi

# Creation mode
# lvm
elif [[ "$1" == "--creator" ]]; then
if [[ "$2" == "--lvm" ]]; then
echo -e "\e[1;4;31mIF ERRORS ARE ENCOUNTERED PLEASE TRY RUNNING THE SCRIPT IN STOPPER MODE FIRST\e[0m"
echo -e "\e[1;4;31mIF THE SCRIPT APPEARS TO HANG WHEN CREATING THE LV PLEASE USE CTRL+C AND IT WILL CONTINUE ON\e[0m"
echo -e "\e[1;34mAttempting to create multiple volume lvm Storage Pool and volume\e[0m"
echo -e "\e[1;34mCreating md2\e[0m"
if [ `grep -c md2 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ]
			then mdadm -CR -amd --assume-clean /dev/md2 -n3 -l5 -e1.2 /dev/sdc5 /dev/sdb5 /dev/sdc5 &> /dev/null
			echo -e "\e[1;32mmd2 created successfully\e[0m"
		elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 0 ] ||[ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 0 ] || [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 0 ]
			then echo -e "\e[1;34mChecking for lvm partitions\e[0m"
			if [ -f /root/parted.sh ]
				then sh parted.sh --lvm; mdadm -CR -amd --assume-clean /dev/md2 -n3 -l5 -e1.2 /dev/sdc5 /dev/sdb5 /dev/sdc5&> /dev/null
				else wget -P /root https://sacmirror.synology.me/host/scripts/parted.sh; sh parted.sh --lvm; mdadm -CR -amd --assume-clean /dev/md2 -n3 -l5 -e1.2 /dev/sdc5 /dev/sdb5 /dev/sdc5 &> /dev/null
				echo -e "\e[1;32mmd2 created successfully\e[0m"
			fi
		fi
	else echo -e "\e[1;32md2 already exists\e[0m"
fi
cat /proc/mdstat
echo -e "\e[1;34mCreating pv0\e[0"
if [ `pvs|grep -c md2` == 0 ]
	then pvcreate /dev/md2 &> /dev/null
	echo -e "\e[1;32mpv0 created sucecssfully\e[0m"
	elif [ `pvs|grep -c md2` == 1 ]
	then echo -e "\e[1;32mpv0 already exists\e[0m"
	else
		echo -e "\e[1;31mmd2 missing or can't be used\e[0m"
fi

pvs
echo -e "\e[1;34mCreating vg1\e[0m"
	if [ `pvs|grep -c md2` == 1 ]
		then vgcreate vg1 /dev/md2&> /dev/null
	echo -e "\e[1;32mvg1 created sucecssfully\e[0m"
	elif [ `vgs|grep -c vg1` == 1 ]
		then echo -e "\e[1;32mvg1 already exists\e[0m"
	else
		echo -e "\e[1;31mEither md2 is missing or can't be used\e[0m"
fi
vgs
echo -e "\e[1;34mCreating lv\e[0m"
if [ `lvm lvscan|grep -c /dev/vg1/volume_1` == 0 ]
	then lvcreate -L 10G -n volume_1 vg1 &> /dev/null; synospace --lv-meta -c /dev/vg1 &> /dev/null
		echo -e "\e[1;32mlv created successfully\e[0m"
	elif [ `lvm lvscan|grep -c /dev/vg1/volume_1` == 1 ]
		then echo -e "\e[1;32mlv already exists\e[0m"
	else
		echo -e "\e[1;31mvg1 is either missing or can't be used\e[0m"
fi
echo -e "\e[1;34mActivating lv"
if [ `lvm lvscan|grep -c ACTIVE` != 2 ]
	then vgchange -ay vg1 &> /dev/null
		echo -e "\e[1;32mlv now active\e[0m"
	elif  [ `lvm lvscan|grep -c ACTIVE` == 2 ]
		then echo -e "\e[1;32mlv already active\e[0m"
	else
		echo -e "\e[1;31mlv missing or can't be used\e[0m"
fi
lvm lvscan
echo -e "\e[1;34mMaking File System\e[0m"
if [ `lvm lvscan|grep -c ACTIVE` == 2 ] && [ `synofstool --get-fs-type /dev/vg1/volume_1|grep -c "ext4"` == 0 ]
	then mkfs.ext4 /dev/vg1/volume_1 &> /dev/null
	elif [ `lvm lvscan|grep -c ACTIVE` == 2 ] && [ `synofstool --get-fs-type /dev/vg1/volume_1|grep -c ext4` == 1 ]
		then echo -e "\e[1;32mFile system already exists\e[0m"
	else
		echo -e "\e[1;31mlv missing or can't be used\e[0m"
fi
echo -e "\e[1;34mChecking file system\e[0m"
synofstool --get-fs-type /dev/vg1/volume_1
echo -e "\e[1;34mMounting volume\e[0m"
if [ `synofstool --get-fs-type /dev/vg1/volume_1|grep -c ext4` == 1 ] && [ `mount|grep -c /volume1` == 0 ]
	then mount /dev/vg1/volume_1 /volume1 &> /dev/null
		echo -e "\e[1;32mVolume mounted\e[0m"
	elif [ `synofstool --get-fs-type /dev/vg1/volume_1|grep -c ext4` == 1 ] && [ `mount|grep -c /volume1` == 1 ]
		then echo -e "\e[1;32mVolume already mounted\e[0m"
	else
		echo -e "\e[1;31mCannot mount /volume1\e[0m"
fi
mount|grep /volume1

# non-lvm
elif [[ "$2" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIF ERRORS ARE ENCOUNTERED PLEASE TRY RUNNING THE SCRIPT IN STOPPER MODE FIRST\e[0m"
echo -e "\e[1;34mAttempting to create single-volume non-lvm RAID Storage Pool volume\e[0m"
echo -e "\e[1;34mCreating md3\e[0m"
if [ `grep -c md3 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ]
			then mdadm -CR -amd --assume-clean /dev/md3 -n3 -l5 -e1.2 /dev/sdd3 /dev/sde3 /dev/sdf3 &> /dev/null
			echo -e "\e[1;32mmd3 created successfully\e[0m"
		elif [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 0 ] || [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 0 ] || [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 0 ]
			then echo -e "\e[1;34mChecking for non-lvmition RAID partitions\e[0m"
			if [ -f parted.sh ]
				then sh parted.sh --non-lvm; mdadm -CR -amd --assume-clean /dev/md3 -n3 -l5 -e1.2 /dev/sdd3 /dev/sde3 /dev/sdf3 &> /dev/null
				else wget -P /root  https://sacmirror.synology.me/host/scripts/parted.sh; sh parted.sh --non-lvm; mdadm -CR -amd --assume-clean /dev/md3 -n3 -l5 -e1.2 /dev/sdd3 /dev/sde3 /dev/sdf3 &> /dev/null
				echo -e "\e[1;32mmd3 created successfully\e[0m"
			fi
		fi
fi
cat /proc/mdstat
echo -e "\e[1;34mMaking File System\e[0m"
if [ `cat /proc/mdstat|grep -c md3` == 1 ] && [ `synofstool --get-fs-type /dev/md3|grep -c "ext4"` == 0 ]
	then mkfs.ext4 /dev/md3 &>/dev/null
		echo -e "\e[1;32mFile system successfully created\e[0m"
		elif [ `cat /proc/mdstat|grep -c md3` == 1 ] && [ `synofstool --get-fs-type /dev/md3|grep -c "ext4"` == 1 ]
			then echo -e "\e[1;32mFile system already exists\e[0m"
	else
		echo -e "\e[1;31mFile system not created, please check that md3 is properly assembled and available"
fi
echo -e "\e[1;34mChecking file system\e[0m"
synofstool --get-fs-type /dev/md3
echo -e "\e[1;34mMounting volume\e[0m"
if [ `synofstool --get-fs-type /dev/md3|grep -c ext4` == 1 ] && [ `mount|grep -c /volume2` == 0 ]
	then mount /dev/md3 /volume2 &> /dev/null
		echo -e "\e[1;32mVolume mounted\e[0m"
	elif [ `synofstool --get-fs-type /dev/md3|grep -c ext4` == 1 ] && [ `mount|grep -c /volume2` == 1 ]
		then echo -e "\e[1;32mVolume already mounted\e[0m"
	else
		echo -e "\e[1;31mCannot mount /volume2\e[0m"
fi
mount|grep /volume2
#
elif [[ "$2" == "--help" ]]; then
	echo "Usage:
                    --lvm : Create lvm volume and array
                    --non-lvm : Create non-lvm RAID array and ext4 volume
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo -e "\e[1;31mInvalid argument. See --help section.\e[0m";
fi

# Breaker mode
# lvm
elif [[ "$1" == "--breaker" ]]; then
if [[ "$2" == "--lvm" ]]; then
echo -e "\e[1;34mAttempting to assemble lvm array with 2 missing disks\e[0m"
echo -e "\e[1;34mStopping lvm volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume1 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting /volume1\e[0m"
	if [ `mount|grep -c "/volume1"` == 1 ]
	then umount /volume1 &> /dev/null
		else echo -e "\e[1;31m/volume1 not mounted or mounted improperly\e[0m"
	fi
	echo -e "\e[1;34mDeactivating vg1\e[0m"
	if [ `mount|grep -c "/volume1"` == 0 ] && [ `lvm lvscan|grep -c "ACTIVE"` != 0 ]
		then vgchange -an vg1 &> /dev/null
		echo -e "\e[1;32mvg1 successully deactivated\e[0m"
		else echo -e "\e[1;31mvg1 could not be deactivated\e[0m"
	fi
	echo -e "\e[1;34mStopping md2\e[0m"
	if [ `grep -c md2 /proc/mdstat` == 1 ]
		then mdadm -S $MD2 &> /dev/null
		echo -e "\e[1;32mmd2 successully stopped\e[0m"
		else echo -e "\e[1;31mmd2 not assembled\e[0m"
	fi
echo -e "\e[1;34mAssembling md2 in crashed state\e[0m"
if [ `grep -c md2 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] &&[ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ]
			then mdadm -AR /dev/md2 /dev/sdc5 &> /dev/null
			echo -e "\e[1;32mmd2 assembled crashed\e[0m"
	else
				echo -e "\e[1;31mCould not assemble\e[0m"
		fi
fi
cat /proc/mdstat

# non-lvm
elif [[ "$2" == "--non-lvm" ]]; then
echo -e "\e[1;34mAttempting to assemble non-lvm RAID array with 2 missing disks\e[0m"
echo -e "\e[1;34mStopping non-lvm RAID volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume2 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting volume\e[0m"
	if [ `mount|grep -c "/volume2"` == 1 ]
		then umount /volume2 &> /dev/null
		echo -e "\e[1;32mVolume unmounted successfully\e[0m"
			else echo -e "\e[1;31m/volume2 not mounted or mounted improperly\e[0m"
	fi
	echo -e "\e[1;34mStopping md3\e[0m"
	if [ `grep -c md3 /proc/mdstat` == 1 ]
		then mdadm -S $MD3 &> /dev/null
		echo -e "\e[1;32mmd3 successully stopped\e[0m"
		else echo "\e1;31mmd3 not assembled\e[0m"
	fi
echo -e "\e[1;34mAssembling md3 in crashed state\e[0m"
if [ `grep -c md3 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ]
			then mdadm -AR /dev/md3 /dev/sdd3 &> /dev/null
			echo -e "\e[1;32mmd3 assembled crashed\e[0m"
	else
				echo -e "\e[1;31mCould not assemble\e[0m"
		fi
fi
cat /proc/mdstat

# Help
elif [[ "$2" == "--help" ]]; then
	echo "Usage:
                    --lvm : unmount and stop lvm volume and array
                    --non-lvm : unmount and stop non-lvm RAID array and ext4 volume
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See --help section.";
fi

# Breaker mode option 2
# lvm
elif [[ "$1" == "--breaker2" ]]; then
if [[ "$2" == "--lvm" ]]; then
echo -e "\e[1;34mAttempting to assemble lvm Storage Pool with a missing disk and a failed disk\e[0m"
echo -e "\e[1;34mStopping lvm volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume1 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting /volume1\e[0m"
	if [ `mount|grep -c "/volume1"` == 1 ]
	then umount /volume1 &> /dev/null
		else echo -e "\e[1;31m/volume1 not mounted or mounted improperly\e[0m"
	fi
	echo -e "\e[1;34mDeactivating vg1\e[0m"
	if [ `mount|grep -c "/volume1"` == 0 ] && [ `lvm lvscan|grep -c "ACTIVE"` != 0 ]
		then vgchange -an vg1 &> /dev/null
		echo -e "\e[1;32mvg1 successully deactivated\e[0m"
		else echo -e "\e[1;31mvg1 could not be deactivated\e[0m"
	fi
	echo -e "\e[1;34mStopping md2\e[0m"
	if [ `grep -c md2 /proc/mdstat` == 1 ]
		then mdadm -S $MD2 &> /dev/null
		echo -e "\e[1;32mmd2 successully stopped\e[0m"
		else echo -e "\e[1;31mmd2 not assembled\e[0m"
	fi
echo -e "\e[1;34mAssembling md2 in crashed state with failed disk\e[0m"
if [ `grep -c md2 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] &&[ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ]
			then mdadm -Af /dev/md2 /dev/sdc5 /dev/sdb5 &> /dev/null
			mdadm -f /dev/md2 /dev/sdb5
			echo -e "\e[1;32mmd2 assembled and crashed\e[0m"
	else
				echo -e "\e[1;31mCould not assemble\e[0m"
		fi
fi
cat /proc/mdstat
echo -e "\e[1;34mMounting volume1\e[0m"
	if [ `lvm lvscan|grep -c ACTIVE` != 2 ] && [ `mount|grep -c /volume1` == 0 ]
		then vgchange -ay;mount /dev/vg1/volume_1 /volume1
		elif [ `lvm lvscan|grep -c ACTIVE` == 2 ] && [ `mount|grep -c /volume1` == 0 ]
		then mount /dev/vg1/volume_1 /volume1
		echo -e "\e[1;32mMount successful\e[0m"
	fi
echo -e "\e[1;34mChecking mount\e[0m"
	if [ `mount|grep -c /volume1` == 1 ]
		then echo -e "\e[1;32mvolume1 working and mounted\e[0m"
		else echo -e "\e[1;31mvolume 1 not mounted\e[0m"
	fi
mount|grep /volume1

# non-lvm
elif [[ "$2" == "--non-lvm" ]]; then
echo -e "\e[1;34mAttempting to assemble non-lvm RAID Storage Pool with a missing disk and a failed disk\e[0m"
echo -e "\e[1;34mStopping non-lvm RAID volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume2 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting volume\e[0m"
	if [ `mount|grep -c "/volume2"` == 1 ]
		then umount /volume2 &> /dev/null
		echo -e "\e[1;32mVolume unmounted successfully\e[0m"
			else echo -e "\e[1;31m/volume2 not mounted or mounted improperly\e[0m"
	fi
	echo -e "\e[1;34mStopping md3\e[0m"
	if [ `grep -c md3 /proc/mdstat` == 1 ]
		then mdadm -S $MD3 &> /dev/null
		echo -e "\e[1;32mmd3 successully stopped\e[0m"
		else echo "\e1;31mmd3 not assembled\e[0m"
	fi
echo -e "\e[1;34mAssembling md3 in crashed state with failed disk\e[0m"
if [ `grep -c md3 /proc/mdstat` == 0 ]
	then
		if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ]
			then mdadm -Af /dev/md3 /dev/sdd3 /dev/sde3 &> /dev/null
			mdadm -f /dev/md3 /dev/sde3
			echo -e "\e[1;32mmd3 assembled crashed\e[0m"
	else
				echo -e "\e[1;31mCould not assemble\e[0m"
		fi
fi
cat /proc/mdstat
echo -e "\e[1;34mMounting volume2\e[0m"
	if [ `grep -c "md3 : active" /proc/mdstat` == 1 ] && [ `mount|grep -c /volume2` == 0 ]
		then mount /dev/md3 /volume2
		echo -e "\e[1;32mMount successful\e[0m"
	fi
echo -e "\e[1;34mChecking mount\e[0m"
	if [ `mount|grep -c /volume2` == 1 ]
		then echo -e "\e[1;32mvolume2 working and mounted\e[0m"
		else echo -e "\e[1;31mvolume 2 not mounted\e[0m"
	fi
mount|grep /volume2

# Help
elif [[ "$2" == "--help" ]]; then
	echo "Usage:
                    --lvm : unmount and stop lvm volume and arrays
                    --non-lvm : unmount and stop non-lvm RAID array and ext4 volume
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See --help section.";
fi

# Stopper mode
# lvm
elif [[ "$1" == "--stopper" ]]; then
if [[ "$2" == "--lvm" ]]; then
echo -e "\e[1;34mAttempting to stop lvm Storage Pool\e[0m"
echo -e "\e[1;34mStopping lvm volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume1 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting volume\e[0m"
	if [ `mount|grep -c "/volume1"` == 1 ]
	then umount /volume1 &> /dev/null
		else echo -e "\e[1;31m/volume1 not mounted or mounted improperly\e[0m"
	fi
	echo -e "\e[1;34mDeactivating vg1\e[0m"
	if [ `mount|grep -c "/volume1"` == 0 ] && [ `lvm lvscan|grep -c "ACTIVE"` != 0 ]
		then vgchange -an vg1 &> /dev/null
		echo -e "\e[1;32mvg1 successully deactivated\e[0m"
		else echo -e "\e[1;31mvg1 could not be deactivated\e[0m"
	fi
	echo -e "\e[1;34mStopping md2\e[0m"
	if [ `grep -c md2 /proc/mdstat` == 1 ]
		then mdadm -S $MD2 &> /dev/null
		echo -e "\e[1;32mmd2 successully stopped\e[0m"
		else echo -e "\e[1;31mmd2 not assembled\e[0m"
	fi

# non-lvm
elif [[ "$2" == "--non-lvm" ]]; then
echo -e "\e[1;34mAttempting to stop non-lvm RAID Storage Pool\e[0m"
echo -e "\e[1;34mStopping non-lvm RAID volume\e[0m"
for pkg in `ls -1 /usr/syno/etc/packages`; do synopkg stop $pkg  &> /dev/null; done
synoservicecfg --stop synomkthumbd &> /dev/null
synoservicecfg --stop synomkflvd &> /dev/null
synoservicecfg --stop synoindexd &> /dev/null
killps /volume2 &> /dev/null
synovspace -all-unload &> /dev/null
echo -e "\e[1;34mUnmounting volume\e[0m"
	if [ `mount|grep -c "/volume2"` == 1 ]
		then umount /volume2 &> /dev/null
		echo -e "\e[1;32mVolume unmounted successfully\e[0m"
			else echo "/volume2 not mounted or mounted improperly[\e[0m"
	fi
	echo -e "\e[1;34mStopping md3\e[0m"
	if [ `grep -c md3 /proc/mdstat` == 1 ]
		then mdadm -S $MD3 &> /dev/null
		echo -e "\e[1;32mmd3 successully stopped\e[0m"
		else echo "md3 not assembled"
	fi
# Help
elif [[ "$2" == "--help" ]]; then
	echo "Usage:
                    --lvm : unmount and stop lvm volume and arrays
                    --non-lvm : unmount and stop non-lvm RAID array and ext4 volume
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See --help section.";
fi

# Help
elif [[ "$1" == "--help" ]]; then
	echo -e "\e[1;31mThis script will only work under specific circumstances. If errors are encountered please put 3TB or larger disks in bay 3 of the head unit and all 5 bays of the expansion unit\e[0m
		Usage:
			\e[1;34m--creator : Run RAID creation commands\e[0m
			\e[1;33m--stopper : Run RAID stop commands\e[0m
			\e[1;32m--fixer : Do fix commands\e[0m
			\e[1;31m--breaker : Run RAID commands to assemble array with multiple disks missing\e[0m
			\e[1;31m--breaker2 : Run RAID commands to assemble array with one disk missing and one failed\e[0m
			--help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo -e "\e[1;32mInvalid argument. See --help section.\e[0m";
fi
