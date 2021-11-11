#!/bin/bash
# written my Matt Wisnowski, 2/16/2016, edited 6/7/2019; edited 10/11/2021
# This script will attempt an automatic RAID recovery of a linux-based generic NAS device
# Please be sure of the number of bays to your device to ensure accuracy
# At this time, the script only supports configurations of 2 bay, 4-bay, 5-bay, and 8-bay units, including expansion units
# This script assumes dat arrays start at md3, if your system starts elsewhere, please replace all instances as needed
# This scrupt supports lvm-based volumes using up to RAID 3 arrays and in either vg1 or vg2
MDSTAT=/proc/mdstat

# 5-bay units
if [[ "$1" == "--5-bay" ]]; then
	if [[ "$2" == "--5disk" ]]; then
		if [[ "$3" == "--lvm" ]]; then
			echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
			echo -e "\e[1;34mChecking which md should be assembled\e[0m"
			if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
				sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
				echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sda5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdb5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdc5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdd5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sde5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
				sh /tmp/md2.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md2` == 1 ]
								then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
						sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
						echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sda6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdb\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdb6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdc\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdc6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdd\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdd6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sde\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sde6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
						sh /tmp/md3.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md3` == 1 ]
								then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
				fi
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
			elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
				sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
				echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sda5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdb5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdc5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdd5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sde5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
				sh /tmp/md3.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md3` == 1 ]
								then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md4, md4, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
						sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
						echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sda6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdb\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdb6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdc\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdc6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdd\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdd6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sde\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sde6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
						sh /tmp/md4.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md4` == 1 ]
								then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md4, md4, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
						echo -e "\e[1;34mChecking if md3 exists\e[0m"
				fi
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
			elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
				sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
				echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sda5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdb5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdc5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdd5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sde5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
				sh /tmp/md4.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md4` == 1 ]
								then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md5, md5, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
						sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
						echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sda6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdb\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdb6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdc\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdc6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sdd\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdd6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						echo -e "\e[1;34mChecking sde\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sde6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
						sh /tmp/md5.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md5` == 1 ]
								then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md5, md5, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
						echo -e "\e[1;34mChecking if md4 exists\e[0m"
				fi
			else echo -e "\e[1;31mSeems mds 2, 3, and 4 are already assembled, please check the space files (if they exist) \e[1;31mor attempt a stop and rerun this script\e[0m"
			fi
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
		elif [[ "$3" == "--non-lvm" ]]; then
			echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
			echo -e "\e[1;34mChecking which md should be assembled\e[0m"
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
			if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
				sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
				echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
				echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sda3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdb3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdc3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdd3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sde3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
				sh /tmp/md2.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md2` == 1 ]
								then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md2\e[0m"
				if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume1
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume2
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume3
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
			elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
				sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
				echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
				echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sda3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdb3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdc3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdd3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sde3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
				sh /tmp/md3.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md3` == 1 ]
								then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md3\e[0m"
				if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume1
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume2
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume3
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
			elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
				sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
				echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
				echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sda3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdb\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdb3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdc\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdc3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sdd\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdd3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				echo -e "\e[1;34mChecking sde\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sde3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
				sh /tmp/md4.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md4` == 1 ]
								then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
							fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md4\e[0m"
				if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume1
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume2
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume3
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			else echo -e "\e[1;31mSeems mds 2, 3, and 4 are already assembled, please check the space files (if they exist) \e[1;31mor attempt a stop and rerun this script\e[0m"
			fi
			elif [[ "$3" == "--help" ]]; then
				echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
			Usage:
			                    --lvm : For use with lvm RAID arrays
			                    --non-lvm : For use with non-lvm RAID arrays
			                    --help : display available options
			            ";
					echo -e "\e[1;34mBlue=Process\e[0m"
					echo -e "\e[1;32mGreen=Successful\e[0m"
					echo -e "\e[1;31mRed=Unsuccessful\e[0m"
			else
			    echo "Invalid argument. See -help section.";
			fi
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
	elif [[ "$2" == "--10disk" ]]; then
		if [[ "$3" == "--lvm" ]]; then
			echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
			echo -e "\e[1;34mChecking which md should be assembled\e[0m"
			if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
				sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
				echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sda5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdb5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdc5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdd5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sde5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdga5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgb5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgc5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgd5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdge5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdha5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhb5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhc5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhd5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhe5 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
				sh /tmp/md2.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md2` == 1 ]
						then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
						sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
						echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sda6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdb6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdc6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdd6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sde6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdga6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdga6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdgb6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdgc6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdgd6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdge6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdge6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdha6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdha6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdhb6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdhc6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdhd6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md3.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhe6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
								echo sdhe6 >> /tmp/md3_drives.txt
							else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
						sh /tmp/md3.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md3` == 1 ]
								then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
				sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
				echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sda5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdb5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdc5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdd5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sde5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdga5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgb5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgc5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgd5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdge5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdha5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhb5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhc5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhd5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhe5 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
				sh /tmp/md3.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md3` == 1 ]
						then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
						sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
						echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sda6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdb6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdc6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdd6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sde6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdga6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdga6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdgb6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdgc6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdgd6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdge6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdge6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdha6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdha6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdhb6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdhc6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdhd6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md4.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhe6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
								echo sdhe6 >> /tmp/md4_drives.txt
							else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
						sh /tmp/md4.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md4` == 1 ]
								then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
				sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
				echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sda5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdb5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdc5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdd5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sde5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdga5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgb5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgc5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgd5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdge5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdha5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhb5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhc5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhd5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhe5 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
				sh /tmp/md4.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md4` == 1 ]
						then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				cat $MDSTAT
				echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
				if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
					then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
					if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
						rm /tmp/sd*.out &> /dev/null
						rm /tmp/md*.out &> /dev/null
						rm /tmp/md*.sh &> /dev/null
						rm /tmp/md*_drives.txt &> /dev/null
						rm /tmp/pvs.out &> /dev/null
						echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
						sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
						echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
						echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
						echo -e "\e[1;34mChecking sda\e[0m"
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
								sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sda6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdb6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdc6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdd6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
								sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sde6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdga6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdga6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdgb6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdgc6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdgd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdgd6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdge6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdge6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdha6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdha6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdhb6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdhc6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdhd6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md5.out` -gt 0 ]
							then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
								sed '$s/$/ \/dev\/sdhe6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
								echo sdhe6 >> /tmp/md5_drives.txt
							else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
						fi
						if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
						then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
						sh /tmp/md5.sh &> /dev/null
							if [ `cat $MDSTAT|grep -c md5` == 1 ]
								then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
								else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
							fi
						else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
						fi
						cat $MDSTAT
						echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
						if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
							then echo -e "\e[1;31mSeems there may still be an md6, md7, etc...  Please check against space files (if they exist)\e[0m"
							elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
								then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
								if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
									then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
										if [ `mount|grep -c vg1` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
										fi
								elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
									then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
										if [ `mount|grep -c vg2` == 1 ]
											then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
											else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
										fi
								fi
							else echo -e "\e[1;31mmd5 doesn't seem to be assembled please perform manual checks\e[0m"
						fi
					fi
					elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
						then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
					else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
				fi
			fi
			#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
		elif [[ "$3" == "--non-lvm" ]]; then
			echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
			echo -e "\e[1;34mChecking which md should be assembled\e[0m"
			if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
				sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
				echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sda3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdb3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdc3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdd3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sde3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdga3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgb3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgc3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdgd3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdge3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdha3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhb3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhc3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhd3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md2.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
						echo sdhe3 >> /tmp/md2_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md2"
				sh /tmp/md2.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md2` == 1 ]
						then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md2\e[0m"
				if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume1
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume2
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
				then mount /dev/md2 /volume3
					if [ `mount|grep -c md2` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
				sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
				echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sda3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdb3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdc3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdd3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sde3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdga3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgb3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgc3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdgd3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdge3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdha3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhb3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhc3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhd3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md3.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
						echo sdhe3 >> /tmp/md3_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md3"
				sh /tmp/md3.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md3` == 1 ]
						then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md3\e[0m"
				if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume1
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume2
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
				then mount /dev/md3 /volume3
					if [ `mount|grep -c md3` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
				rm /tmp/sd*.out &> /dev/null
				rm /tmp/md*.out &> /dev/null
				rm /tmp/md*.sh &> /dev/null
				rm /tmp/md*_drives.txt &> /dev/null
				rm /tmp/pvs.out &> /dev/null
				echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
				sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
				echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
				echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
				echo -e "\e[1;34mChecking sda\e[0m"
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
						sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sda3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdb3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdc3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdd3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
						sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sde3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdga3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdga3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgb3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgc3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdgd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdgd3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdge3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdge3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdha3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdha3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhb3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhc3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhd3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md4.out` -gt 0 ]
					then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
						sed '$s/$/ \/dev\/sdhe3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
						echo sdhe3 >> /tmp/md4_drives.txt
					else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
				fi
				if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
				then echo -e "\e[1;34mAttempting assembly of md4"
				sh /tmp/md4.sh &> /dev/null
					if [ `cat $MDSTAT|grep -c md4` == 1 ]
						then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
						else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
					fi
				else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
				fi
				echo -e "\e[1;34mAttempting mount of md4\e[0m"
				if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume1
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume2
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
					fi
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
				then mount /dev/md4 /volume3
					if [ `mount|grep -c md4` == 1 ]
						then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
						else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
					fi
				fi
				cat $MDSTAT
			fi
		elif [[ "$3" == "--help" ]]; then
				echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
			Usage:
			                    --lvm : For use with lvm RAID arrays
			                    --non-lvm : For use with non-lvm RAID arrays
			                    --help : display available options
			            ";
					echo -e "\e[1;34mBlue=Process\e[0m"
					echo -e "\e[1;32mGreen=Successful\e[0m"
					echo -e "\e[1;31mRed=Unsuccessful\e[0m"
			else
			    echo "Invalid argument. See -help section.";
			fi
	elif [[ "$2" == "--15disk" ]]; then
		if [[ "$3" == "--lvm" ]]; then
		echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
		echo -e "\e[1;34mChecking which md should be assembled\e[0m"
		if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
			sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
			echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sda5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdb5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdc5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdd5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sde5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdga5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgb5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgc5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgd5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdge5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdha5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhb5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhc5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhd5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhe5 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
			sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
				if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
					rm /tmp/sd*.out &> /dev/null
					rm /tmp/md*.out &> /dev/null
					rm /tmp/md*.sh &> /dev/null
					rm /tmp/md*_drives.txt &> /dev/null
					rm /tmp/pvs.out &> /dev/null
					echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
					sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
					echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
					echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
					echo -e "\e[1;34mChecking sda\e[0m"
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
							sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sda6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdb6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdc6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdd6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
							sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sde6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdga6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdga6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdgb6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdgc6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdgd6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdge6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdge6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdha6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdha6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdhb6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdhc6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdhd6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md3.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhe6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
							echo sdhe6 >> /tmp/md3_drives.txt
						else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
					then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
					sh /tmp/md3.sh &> /dev/null
						if [ `cat $MDSTAT|grep -c md3` == 1 ]
							then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
							else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
						fi
					else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
					fi
					cat $MDSTAT
					echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
					if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
						then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
						elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
							then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
						else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
					fi
				fi
				elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
						if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sde5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdga5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgb5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgc5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgd5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdge5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdha5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhb5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhc5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhd5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhe5 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
				if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
					rm /tmp/sd*.out &> /dev/null
					rm /tmp/md*.out &> /dev/null
					rm /tmp/md*.sh &> /dev/null
					rm /tmp/md*_drives.txt &> /dev/null
					rm /tmp/pvs.out &> /dev/null
					echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
					sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
					echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
					echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
					echo -e "\e[1;34mChecking sda\e[0m"
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
							sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sda6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdb6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdc6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdd6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
							sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sde6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdga6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdga6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdgb6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdgc6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdgd6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdge6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdge6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdha6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdha6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdhb6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdhc6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdhd6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md4.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhe6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
							echo sdhe6 >> /tmp/md4_drives.txt
						else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
					then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
					sh /tmp/md4.sh &> /dev/null
						if [ `cat $MDSTAT|grep -c md4` == 1 ]
							then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
							else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
						fi
					else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
					fi
					cat $MDSTAT
					echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
					if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
						then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
						elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
							then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
						else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
					fi
				fi
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
						if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sde5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdga5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgb5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgc5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgd5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdge5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha5` == 1 ] && [ `grep -c sdha5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdha5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb5` == 1 ] && [ `grep -c sdhb5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhb5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc5` == 1 ] && [ `grep -c sdhc5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhc5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd5` == 1 ] && [ `grep -c sdhd5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhd5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe5` == 1 ] && [ `grep -c sdhe5 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhe5 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
				if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
					rm /tmp/sd*.out &> /dev/null
					rm /tmp/md*.out &> /dev/null
					rm /tmp/md*.sh &> /dev/null
					rm /tmp/md*_drives.txt &> /dev/null
					rm /tmp/pvs.out &> /dev/null
					echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
					sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
					echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
					echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
					echo -e "\e[1;34mChecking sda\e[0m"
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
							sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sda6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdb6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdc6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdd6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
							sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sde6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdga6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdga6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdgb6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdgc6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdgd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdgd6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdge6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdge6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha6` == 1 ] && [ `grep -c sdha6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdha6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdha6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb6` == 1 ] && [ `grep -c sdhb6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdhb6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc6` == 1 ] && [ `grep -c sdhc6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdhc6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd6` == 1 ] && [ `grep -c sdhd6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdhd6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe6` == 1 ] && [ `grep -c sdhe6 /tmp/md5.out` -gt 0 ]
						then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
							sed '$s/$/ \/dev\/sdhe6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
							echo sdhe6 >> /tmp/md5_drives.txt
						else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
					fi
					if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
					then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
					sh /tmp/md5.sh &> /dev/null
						if [ `cat $MDSTAT|grep -c md5` == 1 ]
							then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
							else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
						fi
					else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
					fi
					cat $MDSTAT
					echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
					if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
						then echo -e "\e[1;31mSeems there may still be an md6, md7, etc...  Please check against space files (if they exist)\e[0m"
						elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
							then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
							if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
								then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
									if [ `mount|grep -c vg1` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
									fi
							elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
								then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
									if [ `mount|grep -c vg2` == 1 ]
										then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
										else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
									fi
							fi
						else echo -e "\e[1;31mmd5 doesn't seem to be assembled please perform manual checks\e[0m"
					fi
				fi
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
						if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
								if [ `mount|grep -c vg1` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
								fi
						elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
							then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
								if [ `mount|grep -c vg2` == 1 ]
									then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
									else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
								fi
						fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
		elif [[ "$3" == "--non-lvm" ]]; then
		echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
		echo -e "\e[1;34mChecking which md should be assembled\e[0m"
		if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
			sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
			echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sda3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdb3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdc3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdd3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sde3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdga3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgb3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgc3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdgd3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdge3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdha3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhb3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhc3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhd3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md2.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
					echo sdhe3 >> /tmp/md2_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md2"
			sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			echo -e "\e[1;34mAttempting mount of md2\e[0m"
			if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
			then mount /dev/md2 /volume1
				if [ `mount|grep -c md2` == 1 ]
					then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
			then mount /dev/md2 /volume2
				if [ `mount|grep -c md2` == 1 ]
					then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
			then mount /dev/md2 /volume3
				if [ `mount|grep -c md2` == 1 ]
					then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
				fi
			fi
			cat $MDSTAT
		elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sde3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdga3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgb3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgc3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgd3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdge3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdha3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhb3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhc3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhd3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdhe3 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			echo -e "\e[1;34mAttempting mount of md3\e[0m"
			if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
			then mount /dev/md3 /volume1
				if [ `mount|grep -c md3` == 1 ]
					then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
			then mount /dev/md3 /volume2
				if [ `mount|grep -c md3` == 1 ]
					then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
			then mount /dev/md3 /volume3
				if [ `mount|grep -c md3` == 1 ]
					then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
				fi
			fi
			cat $MDSTAT
		elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sde3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdga3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgb3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgc3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgd3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdge3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdha3` == 1 ] && [ `grep -c sdha3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdha to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdha3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdha3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdha doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhb3` == 1 ] && [ `grep -c sdhb3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhb3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhc3` == 1 ] && [ `grep -c sdhc3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhc3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhd3` == 1 ] && [ `grep -c sdhd3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhd3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdhe3` == 1 ] && [ `grep -c sdhe3 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdhe to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdhe3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdhe3 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdhe doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			echo -e "\e[1;34mAttempting mount of md4\e[0m"
			if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
			then mount /dev/md4 /volume1
				if [ `mount|grep -c md4` == 1 ]
					then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
			then mount /dev/md4 /volume2
				if [ `mount|grep -c md4` == 1 ]
					then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
				fi
			elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
			then mount /dev/md4 /volume3
				if [ `mount|grep -c md4` == 1 ]
					then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
					else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
				fi
			fi
			cat $MDSTAT
		fi
		elif [[ "$3" == "--help" ]]; then
			echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
		Usage:
		                    --lvm : For use with lvm RAID arrays
		                    --non-lvm : For use with non-lvm RAID arrays
		                    --help : display available options
		            ";
				echo -e "\e[1;34mBlue=Process\e[0m"
				echo -e "\e[1;32mGreen=Successful\e[0m"
				echo -e "\e[1;31mRed=Unsuccessful\e[0m"
		else
		    echo "Invalid argument. See -help section.";
		fi
	elif [[ "$2" == "--help" ]]; then
		echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
	Usage:
	                    --5disk : For use with just a base 5-bay unit
	                    --10disk : For use with a 5-bay unit and expansion
	                    --15disk : For use with a 5-bay unit and 2 expansions
	                    --help : display available options
	            ";
			echo -e "\e[1;34mBlue=Process\e[0m"
			echo -e "\e[1;32mGreen=Successful\e[0m"
			echo -e "\e[1;31mRed=Unsuccessful\e[0m"
	else
	    echo "Invalid argument. See -help section.";
	fi
# 8-bay units
elif [[ "$1" == "--8-bay" ]]; then
if [[ "$2" == "--8disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sde\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sde6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdf6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdg6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdh6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sde\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sde6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdf6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdg6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdh6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sde\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sde6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdf6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdg6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdh6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sde\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$2" == "--13disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdia5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdib5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdic5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdid5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdie5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdja5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdje5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md2` == 1 ]
			then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sde6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdf6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdg6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdh6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdia6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdib6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdic6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdid6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdie6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdja6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdje6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdia5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdib5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdic5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdid5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdie5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdja5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdje5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md3` == 1 ]
			then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sde6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdf6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdg6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdh6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdia6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdib6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdic6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdid6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdie6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdja6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdje6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdia5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdib5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdic5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdid5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdie5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdja5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdje5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md4` == 1 ]
			then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sde6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdf6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdg6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdh6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdia6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdib6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdic6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdid6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdie6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdja6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdje6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdia3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdib3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdic3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdid3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdie3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdja3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdje3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdia3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdib3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdic3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdid3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdie3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdja3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdje3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdia3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdib3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdic3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdid3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdie3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdja3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdje3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
elif [[ "$2" == "--18disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdia5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdib5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdic5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdid5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdie5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdja5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdje5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md2` == 1 ]
			then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sde6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdf6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdg6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdh6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdia6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdib6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdic6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdid6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdie6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdja6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdjd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdje6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdia5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdib5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdic5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdid5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdie5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdja5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdje5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md3` == 1 ]
			then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sde6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdf6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdg6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdh6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdia6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdib6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdic6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdid6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdie6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdja6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdjd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdje6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde5` == 1 ] && [ `grep -c sde5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf5` == 1 ] && [ `grep -c sdf5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg5` == 1 ] && [ `grep -c sdg5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh5` == 1 ] && [ `grep -c sdh5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia5` == 1 ] && [ `grep -c sdia5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdia5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib5` == 1 ] && [ `grep -c sdib5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdib5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic5` == 1 ] && [ `grep -c sdic5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdic5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid5` == 1 ] && [ `grep -c sdid5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdid5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie5` == 1 ] && [ `grep -c sdie5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdie5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja5` == 1 ] && [ `grep -c sdja5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdja5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb5` == 1 ] && [ `grep -c sdjb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc5` == 1 ] && [ `grep -c sdjc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd5` == 1 ] && [ `grep -c sdjd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje5` == 1 ] && [ `grep -c sdje5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdje5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md4` == 1 ]
			then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde6` == 1 ] && [ `grep -c sde6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
					sed '$s/$/ \/dev\/sde6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sde6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf6` == 1 ] && [ `grep -c sdf6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdf6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdf6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg6` == 1 ] && [ `grep -c sdg6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdg6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdg6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh6` == 1 ] && [ `grep -c sdh6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdh6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdh6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia6` == 1 ] && [ `grep -c sdia6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdia6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdia6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib6` == 1 ] && [ `grep -c sdib6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdib6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdib6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic6` == 1 ] && [ `grep -c sdic6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdic6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdic6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid6` == 1 ] && [ `grep -c sdid6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdid6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdid6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie6` == 1 ] && [ `grep -c sdie6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdie6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdie6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja6` == 1 ] && [ `grep -c sdja6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdja6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdja6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb6` == 1 ] && [ `grep -c sdjb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc6` == 1 ] && [ `grep -c sdjc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd6` == 1 ] && [ `grep -c sdjd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdjd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdjd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje6` == 1 ] && [ `grep -c sdje6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdje6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdje6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sde3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdf3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdg3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdh3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdia3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdib3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdic3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdid3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdie3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdja3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdjd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdje3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sde3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdf3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdg3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdh3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdia3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdib3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdic3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdid3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdie3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdja3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdjd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdje3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sde3` == 1 ] && [ `grep -c sde3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sde to assembly script\e[0m"
			sed '$s/$/ \/dev\/sde3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sde3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msde doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdf3` == 1 ] && [ `grep -c sdf3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdf to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdf3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdf3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdf doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdg3` == 1 ] && [ `grep -c sdg3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdg to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdg3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdg3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdg doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdh3` == 1 ] && [ `grep -c sdh3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdh to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdh3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdh3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdh doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdia3` == 1 ] && [ `grep -c sdia3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdia to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdia3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdia3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdia doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdib3` == 1 ] && [ `grep -c sdib3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdib to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdib3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdib3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdib doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdic3` == 1 ] && [ `grep -c sdic3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdic to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdic3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdic3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdic doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdid3` == 1 ] && [ `grep -c sdid3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdid to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdid3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdid3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdid doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdie3` == 1 ] && [ `grep -c sdie3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdie to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdie3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdie3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdie doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdja3` == 1 ] && [ `grep -c sdja3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdja to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdja3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdja3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdja doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjb3` == 1 ] && [ `grep -c sdjb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjc3` == 1 ] && [ `grep -c sdjc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdjd3` == 1 ] && [ `grep -c sdjd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdjd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdjd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdjd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdjd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdje3` == 1 ] && [ `grep -c sdje3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdje to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdje3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdje3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdje doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
elif [[ "$2" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    --8disk : For use with just a base 18-bay unit
                    --13disk : For use with a 18-bay unit and expansion
                    --18disk : For use with a 18-bay unit and 2 expansions
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi

# 4-bay units
elif [[ "$1" == "--4-bay" ]]; then
if [[ "$2" == "--4disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdc\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdd\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdc\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdd\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$2" == "--9disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdga5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdge5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2"
	sh /tmp/md2.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md2` == 1 ]
			then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
			else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
		fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdga6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdge6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdga5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdge5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3"
	sh /tmp/md3.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md3` == 1 ]
			then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
			else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
		fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdga6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdge6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc5` == 1 ] && [ `grep -c sdc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd5` == 1 ] && [ `grep -c sdd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdga5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdge5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4"
	sh /tmp/md4.sh &> /dev/null
		if [ `cat $MDSTAT|grep -c md4` == 1 ]
			then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
			else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
		fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc6` == 1 ] && [ `grep -c sdc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
				else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd6` == 1 ] && [ `grep -c sdd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
				else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdga6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdge6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdga3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdge3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdga3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdge3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdc3` == 1 ] && [ `grep -c sdc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdd3` == 1 ] && [ `grep -c sdd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdga3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdge3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
elif [[ "$2" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    --4disk : For use with just a base 5-bay unit unit
                    --9disk : For use with a 5-bay unit and expansion
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi

# 2-bay/7-bay units
elif [[ "$1" == "--2-bay" ]]; then
if [[ "$2" == "--2disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    -lvm : For use with lvm RAID arrays
                    -non-lvm : For use with non-lvm RAID arrays
                    -help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
elif [[ "$2" == "--7disk" ]]; then
if [[ "$3" == "--lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdga5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgb5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgc5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgd5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdge5 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md3, md4, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md3` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
			sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
			echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sda6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdga6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgb6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgc6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdgd6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md3.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
					echo sdge6 >> /tmp/md3_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md3_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
			sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md3, md4, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd2 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdga5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgb5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgc5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgd5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdge5 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md4, md5, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md4` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
			sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
			echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sda6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdga6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgb6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgc6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdgd6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md4.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
					echo sdge6 >> /tmp/md4_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md4_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
			sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md4, md5, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd3 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda5` == 1 ] && [ `grep -c sda5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb5` == 1 ] && [ `grep -c sdb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga5` == 1 ] && [ `grep -c sdga5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdga5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb5` == 1 ] && [ `grep -c sdgb5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgb5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc5` == 1 ] && [ `grep -c sdgc5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgc5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd5` == 1 ] && [ `grep -c sdgd5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgd5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge5` == 1 ] && [ `grep -c sdge5 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge5/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdge5 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*5\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	cat $MDSTAT
	echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
	if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
		then echo -e "\e[1;32mSeems there may be an md5, md6, etc...\e[0m"
		if [ `cat $MDSTAT|grep -c md5` == 0 ]; then
			rm /tmp/sd*.out &> /dev/null
			rm /tmp/md*.out &> /dev/null
			rm /tmp/md*.sh &> /dev/null
			rm /tmp/md*_drives.txt &> /dev/null
			rm /tmp/pvs.out &> /dev/null
			echo -e "\e[1;34mExporting md5 data from space files (if they exist)\e[0m"
			sed -n '/md5/,/raid>/p' /etc/space/space_history_201* >> /tmp/md5.out
			echo "mdadm -Af /dev/md5" >> /tmp/md5.sh
			echo -e "\e[1;34mChecking for valid lvm partitions\e[0m"
			echo -e "\e[1;34mChecking sda\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda6` == 1 ] && [ `grep -c sda6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
					sed '$s/$/ \/dev\/sda6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sda6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
			fi
			echo -e "\e[1;34mChecking sdb\e[0m"
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb6` == 1 ] && [ `grep -c sdb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga6` == 1 ] && [ `grep -c sdga6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdga6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdga6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb6` == 1 ] && [ `grep -c sdgb6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgb6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgb6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc6` == 1 ] && [ `grep -c sdgc6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgc6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgc6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd6` == 1 ] && [ `grep -c sdgd6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdgd6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdgd6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge6` == 1 ] && [ `grep -c sdge6 /tmp/md5.out` -gt 0 ]
				then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
					sed '$s/$/ \/dev\/sdge6/' /tmp/md5.sh > /tmp/_md5.sh_ && mv -- /tmp/_md5.sh_ /tmp/md5.sh
					echo sdge6 >> /tmp/md5_drives.txt
				else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
			fi
			if [ -f /tmp/md5.sh ] && [ `grep -c '\<sd.*6\>' /tmp/md5_drives.txt` -gt 0 ]
			then echo -e "\e[1;34mAttempting assembly of md5\e[0m"
			sh /tmp/md5.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md5` == 1 ]
					then echo -e "\e[1;32mmd5 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd5 unsuccessfully assembled please perform manual checks\e[0m"
				fi
			else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
			fi
			cat $MDSTAT
			echo -e "\e[1;34mChecking if additional arrays may need assembly\e[0m"
			if [ `pvs 2>&1|grep -c "find device with uuid"` -ge 1 ]
				then echo -e "\e[1;31mSeems there may still be an md5, md6, etc...  Please check against space files (if they exist)\e[0m"
				elif [ `cat $MDSTAT|grep -c md5` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
					then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
					if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
						then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
							if [ `mount|grep -c vg1` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
							fi
					elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
						then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
							if [ `mount|grep -c vg2` == 1 ]
								then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
								else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
							fi
					fi
				else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
			fi
		fi
		elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `pvs 2>&1|grep -c "find device with uuid"` == 0 ]
			then echo -e "\e[1;32mActivating vg and mounting volume\e[0m"
				if [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_1 /volume1
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_2 /volume2
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg1` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg1/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg1; mount /dev/vg1/volume_3 /volume3
						if [ `mount|grep -c vg1` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg1` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_1 /volume1
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_2 /volume2
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
						fi
				elif [ `lvm lvscan 2>&1|grep -c vg2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/vg2/p' /etc/space/space_history_201*|grep -c vg2` -ge 0 ]
					then vgchange -ay vg2; mount /dev/vg2/volume_3 /volume3
						if [ `mount|grep -c vg2` == 1 ]
							then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
							else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
						fi
				fi
		else echo -e "\e[1;31mmd4 doesn't seem to be assembled please perform manual checks\e[0m"
	fi
fi
#written my Matt Wisnowski, February 16, 2016, edited June 27, 2019
elif [[ "$3" == "--non-lvm" ]]; then
echo -e "\e[1;4;31mIf errors are encountered, double check the space files (if they exist)\e[0m"
echo -e "\e[1;34mChecking which md should be assembled\e[0m"
if [ `cat $MDSTAT|grep -c md2` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md2 data from space files (if they exist)\e[0m"
	sed -n '/md2/,/raid>/p' /etc/space/space_history_201* >> /tmp/md2.out
	echo "mdadm -Af /dev/md2" >> /tmp/md2.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sda3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdga3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgb3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgc3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdgd3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md2.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md2.sh > /tmp/_md2.sh_ && mv -- /tmp/_md2.sh_ /tmp/md2.sh
			echo sdge3 >> /tmp/md2_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md2.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md2_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md2\e[0m"
	sh /tmp/md2.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md2` == 1 ]
					then echo -e "\e[1;32mmd2 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd2 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md2\e[0m"
	if [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume1
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume2
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md2` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md2/p' /etc/space/space_history_201*|grep -c md2` -ge 0 ]
	then mount /dev/md2 /volume3
		if [ `mount|grep -c md2` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md3` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md3 data from space files (if they exist)\e[0m"
	sed -n '/md3/,/raid>/p' /etc/space/space_history_201* >> /tmp/md3.out
	echo "mdadm -Af /dev/md3" >> /tmp/md3.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sda3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdga3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgb3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgc3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdgd3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md3.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md3.sh > /tmp/_md3.sh_ && mv -- /tmp/_md3.sh_ /tmp/md3.sh
			echo sdge3 >> /tmp/md3_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md3.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md3_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md3\e[0m"
	sh /tmp/md3.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md3` == 1 ]
					then echo -e "\e[1;32mmd3 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd3 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md3\e[0m"
	if [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume1
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume2
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md3` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md3/p' /etc/space/space_history_201*|grep -c md3` -ge 0 ]
	then mount /dev/md3 /volume3
		if [ `mount|grep -c md3` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
elif [ `cat $MDSTAT|grep -c md4` == 0 ]; then
	rm /tmp/sd*.out &> /dev/null
	rm /tmp/md*.out &> /dev/null
	rm /tmp/md*.sh &> /dev/null
	rm /tmp/md*_drives.txt &> /dev/null
	rm /tmp/pvs.out &> /dev/null
	echo -e "\e[1;34mExporting md4 data from space files (if they exist)\e[0m"
	sed -n '/md4/,/raid>/p' /etc/space/space_history_201* >> /tmp/md4.out
	echo "mdadm -Af /dev/md4" >> /tmp/md4.sh
	echo -e "\e[1;34mChecking for valid non-lvm RAID partitions\e[0m"
	echo -e "\e[1;34mChecking sda\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sda3` == 1 ] && [ `grep -c sda3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sda to assembly script\e[0m"
			sed '$s/$/ \/dev\/sda3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sda3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msda doesn't seem to have been part of volume 1\e[0m"
	fi
	echo -e "\e[1;34mChecking sdb\e[0m"
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdb3` == 1 ] && [ `grep -c sdb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdga3` == 1 ] && [ `grep -c sdga3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdga to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdga3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdga3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdga doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgb3` == 1 ] && [ `grep -c sdgb3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgb to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgb3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgb3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgb doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgc3` == 1 ] && [ `grep -c sdgc3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgc to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgc3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgc3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgc doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdgd3` == 1 ] && [ `grep -c sdgd3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdgd to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdgd3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdgd3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdgd doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ `sfdisk -l 2>/dev/null|grep -c /dev/sdge3` == 1 ] && [ `grep -c sdge3 /tmp/md4.out` -gt 0 ]
		then echo -e "\e[1;32mAdding sdge to assembly script\e[0m"
			sed '$s/$/ \/dev\/sdge3/' /tmp/md4.sh > /tmp/_md4.sh_ && mv -- /tmp/_md4.sh_ /tmp/md4.sh
			echo sdge3 >> /tmp/md4_drives.txt
		else echo -e "\e[1;32msdge doesn't seem to have been part of volume 1\e[0m"
	fi
	if [ -f /tmp/md4.sh ] && [ `grep -c '\<sd.*3\>' /tmp/md4_drives.txt` -gt 0 ]
	then echo -e "\e[1;34mAttempting assembly of md4\e[0m"
	sh /tmp/md4.sh &> /dev/null
				if [ `cat $MDSTAT|grep -c md4` == 1 ]
					then echo -e "\e[1;32mmd4 successfully assembled\e[0m"
					else echo -e "\e[1;31mmd4 unsuccessfully assembled please perform manual checks\e[0m"
				fi
	else echo -e "\e[1;31mThere doesn't appear to be enough usable drives, maybe other disks were used?\e[0m"
	fi
	echo -e "\e[1;34mAttempting mount of md4\e[0m"
	if [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume1` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume1\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume1
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 1 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 1 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume2` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume2\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume2
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 2 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 2 seemingly mounted unsuccessfully\e[0m"
		fi
	elif [ `cat $MDSTAT|grep -c md4` == 1 ] && [ `mount|grep -c volume3` == 0 ] && [ `sed -n '/volume\ path\=\"\/volume3\"/,/md4/p' /etc/space/space_history_201*|grep -c md4` -ge 0 ]
	then mount /dev/md4 /volume3
		if [ `mount|grep -c md4` == 1 ]
			then echo -e "\e[1;32mVolume 3 mounted successfully\e[0m"
			else echo -e "\e[1;31mVolume 3 seemingly mounted unsuccessfully\e[0m"
		fi
	fi
	cat $MDSTAT
fi
elif [[ "$3" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    --lvm : For use with lvm RAID arrays
                    --non-lvm : For use with non-lvm RAID arrays
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";
fi
elif [[ "$2" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    --2disk : For use with just a 2 bay or 7-bay unit without expansion unit
                    --7disk : For use with a 2 bay or 7-bay unit with expansion unit
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See --help section.";
fi
elif [[ "$1" == "--help" ]]; then
	echo -e "\e[1;4;31mAlways check the space files (if they exist) first to determine correct mode\e[0m
Usage:
                    --5-bay : For use on 15-bay units (including expasnsions)
                    --8-bay : For use on 18-bay units (including expasnsions)
                    --2-bay : For use on 2-bay units (including expasnsions)
                    --4-bay : For use on 4-bay units (including expasnsions)
                    --help : display available options
            ";
		echo -e "\e[1;34mBlue=Process\e[0m"
		echo -e "\e[1;32mGreen=Successful\e[0m"
		echo -e "\e[1;31mRed=Unsuccessful\e[0m"
else
    echo "Invalid argument. See -help section.";fi
