#!/bin/bash

GREEN="\033[0;32m"

RED="\033[0;31m"

NC="\033[0m"

bold=$(tput bold)

normal=$(tput sgr0)

####################################### VERIFICATION ######################################



####################################### 1.1 to 3.10 ######################################



trap '' 2

trap '' SIGTSTP



checktmp=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab`



if [ -z "$checktmp" ]

then

	echo "${RED} 1. /tmp - FAILED (A separate /tmp partition has not been created.)${NC}"

else

	checknodev=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nodev`

	checknodev1=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep nodev`

	if [ -z "$checknodev" -a -z "$checknodev1" ]

	then

		echo "${RED}1. /tmp - FAILED (/tmp not mounted with nodev option)${NC}"

	elif [ -z "$checknodev" -a -n "$checknodev1" ]

	then

		echo "${RED}1. /tmp - FAILED (/tmp not mounted persistently with nodev option)${NC}"

	elif [ -n "$checknodev" -a -z "$checknodev1" ]

	then

		echo "${RED}1. /tmp - FAILED (/tmp currently not mounted with nodev option)${NC}"

	else

		checknosuid=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nosuid`

		checknosuid1=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep nosuid`

		if [ -z "$checknosuid" -a -z "$checknosuid1" ]

		then

			echo "${RED}1. /tmp - FAILED (/tmp not mounted with nosuid option)${NC}"

		elif [ -z "$checknosuid" -a -n "$checknosuid1" ]

		then

			echo "${RED}1. /tmp - FAILED (/tmp not mounted persistently with nosuid option)${NC}"

		elif [ -n "$checknosuid" -a -z "$checknosuid1" ]

		then

			echo "${RED}1. /tmp - FAILED (/tmp currently not mounted with nosuid option)${NC}"

		else	

			checknoexec=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep noexec`

			checknoexec1=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep noexec`

			if [ -z "$checknoexec" -a -z "$checknoexec1" ]

			then

				echo "${RED}1. /tmp - FAILED (/tmp not mounted with noexec option)${NC}"

			elif [ -z "$checknoexec" -a -n "$checknoexec1" ]

			then

				echo "${RED}1. /tmp - FAILED (/tmp not mounted persistently with noexec option)${NC}"

			elif [ -n "$checknoexec" -a -z "$checknoexec1" ]

			then

				echo "${RED}1. /tmp - FAILED (/tmp currently not mounted with noexec option)${NC}"

			else

				echo "${GREEN}1. /tmp - PASSED (/tmp is a separate partition with nodev,nosuid,noexec option)${NC}"

			fi

		fi

	fi

fi

 

checkvar=` grep "[[:space:]]/var[[:space:]]" /etc/fstab`

if [ -z "$checkvar" ]

then

	echo "${RED}2. /var - FAILED (A separate /var partition has not been created.)${NC}"

else 

	echo "${GREEN}2. /var - PASSED (A separate /var partition has been created)${NC}"

fi	



checkbind=`grep -e "^/tmp[[:space:]]" /etc/fstab | grep /var/tmp` 

checkbind1=`mount | grep /var/tmp`

if [ -z "$checkbind" -a -z "$checkbind1" ]

then

	echo "${RED}3. /var/tmp - FAILED (/var/tmp mount is not bounded to /tmp)${NC}"

elif [ -z "$checkbind" -a -n "$checkbind1" ]

then

	echo "${RED}3. /var/tmp - FAILED (/var/tmp mount has not been binded to /tmp persistently.)${NC}"

elif [ -n "$checkbind" -a -z "$checkbind1" ]

then

	echo "${RED}3. /var/tmp - FAILED (/var/tmp mount is not currently bounded to /tmp)${NC}"

else 

	echo "${GREEN}3. /var/tmp - PASSED (/var/tmp has been binded and mounted to /tmp)${NC}"

fi



checkvarlog=`grep "[[:space:]]/var/log[[:space:]]" /etc/fstab`

if [ -z "$checkvarlog" ]

then

	echo "${RED}4. /var/log - FAILED (A separate /var/log partition has not been created.)${NC}"

else 

	echo "${GREEN}4. /var/log - PASSED (A separate /var/log partition has been created)${NC}"

fi	



checkvarlogaudit=`grep "[[:space:]]/var/log/audit[[:space:]]" /etc/fstab`

if [ -z "$checkvarlogaudit" ]

then

	echo "${RED}5. /var/log/audit - FAILED (A separate /var/log/audit partition has not been created.)${NC}"

else 

	echo "${GREEN}5. /var/log/audit - PASSED (A separate /var/log/audit partition has been created)${NC}"

fi	



checkhome=` grep "[[:space:]]/home[[:space:]]" /etc/fstab`

if [ -z "$checkhome" ]

then

	echo "${RED}6. /home - FAILED (A separate /home partition has not been created.)${NC}"

else 

	 checknodevhome=`grep "[[:space:]]/home[[:space:]]" /etc/fstab | grep nodev`

	 checknodevhome1=`mount | grep "[[:space:]]/home[[:space:]]" | grep nodev`

	

		if [ -z "$checknodevhome" -a -z "$checknodevhome1" ]

		then

			echo "${RED}6. /home - FAILED (/home not mounted with nodev option)${NC}"

		elif [ -z "$checknodevhome" -a -n "$checknodevhome1" ]

		then

			echo "${RED}6. /home - FAILED (/home not mounted persistently with nodev option)${NC}"

		elif [ -n "$checknodevhome" -a -z "$checknodevhome1" ]

		then

			echo "${RED}6. /home - FAILED (/home currently not mounted with nodev option)${NC}"

	else

		echo "${GREEN}6. /home - PASSED (/home is a separate partition with nodev option)${NC}"

	fi

fi



cdcheck=`grep cd /etc/fstab`

if [ -n "$cdcheck" ]

then

	cdnodevcheck=`grep cdrom /etc/fstab | grep nodev`

	cdnosuidcheck=`grep cdrom /etc/fstab | grep nosuid`

	cdnosuidcheck=`grep cdrom /etc/fstab | grep noexec`

	if [ -z "$cdnosuidcheck" ]

	then

			echo "${RED}7. /cdrom - FAILED (/cdrom not mounted with nodev option)${NC}"

	elif [ -z "$cdnosuidcheck" ]

	then

			echo "${RED}7. /cdrom - FAILED (/cdrom not mounted with nosuid option)${NC}"

	elif [ -z "$cdnosuidcheck" ]

	then

			echo "${RED}7. /cdrom - FAILED (/cdrom not mounted with noexec option)${NC}"

	else

		"${GREEN}7. /cdrom - PASSED (/cdrom is a mounted with nodev,nosuid,noexec option)${NC}"

	fi

else

	echo "${GREEN}7. /cdrom - PASSED (/cdrom not mounted)${NC}"

fi

 

checkstickybit=`df --local -P | awk {'if (NR1=1) print $6'} | xargs -l '{}' -xdev -type d \(--perm -0002 -a ! -perm -1000 \) 2> /dev/null`

if [ -n "$checkstickybit" ]

then

	echo "${RED}8. Sticky Bit - FAILED (Sticky bit is not set on all world-writable directories)${NC}"

else

	echo "${GREEN}8. Sticky Bit - PASSED (Sticky bit is set on all world-writable directories)${NC}"

fi



checkcramfs=`/sbin/lsmod | grep cramfs`

checkfreevxfs=`/sbin/lsmod | grep freevxfs`

checkjffs2=`/sbin/lsmod | grep jffs2`

checkhfs=`/sbin/lsmod | grep hfs`

checkhfsplus=`/sbin/lsmod | grep hfsplus`

checksquashfs=`/sbin/lsmod | grep squashfs`

checkudf=`/sbin/lsmod | grep udf`



if [ -n "$checkcramfs" -o -n "$checkfreevxfs" -o -n "$checkjffs2" -o -n "$checkhfs" -o -n "$checkhfsplus" -o -n "$checksquashfs" -o -n "$checkudf" ]

then

	echo "${RED}8. Legacy File Systems - FAILED (Not all legacy file systems are disabled i.e. cramfs, freevxfs, jffs2, hfs, hfsplus, squashfs and udf)${NC}"

else

	echo "${GREEN}8. Legacy File Systems - PASSED (All legacy file systems are disabled i.e. cramfs, freevxfs, jffs2, hfs, hfsplus, squashfs and udf)${NC}"

fi



printf "\n"

printf "Services\n"



services=( "telnet" "telnet-server" "rsh-server" "rsh" "ypserv" "ypbind" "tftp" "tftp-server" "xinetd" )



count=1

for eachservice in ${services[*]}

do 

	yum -q list installed $eachservice &>/dev/null && echo "$count. $eachservice - FAILED ($eachservice is Installed)" || echo "$count. $eachservice - PASSED ($eachservice is not installed) "

	((count++))

done 	





chkservices=( "chargen-stream" "daytime-dgram" "daytime-stream" "echo-dgram" "echo-stream" "tcpmux-server" ) 



for eachchkservice in ${chkservices[*]}

do 

	checkxinetd=`yum list xinetd | grep "Available Packages"`

	if [ -n "$checkxinetd" ]

	then

		echo "$count. Xinetd is not installed, hence $eachchkservice is not installed"

		((count++))

	else

		checkchkservices=`chkconfig --list $eachchkservice | grep "off"`

		if [ -n "$checkchkservices" ]

		then 

			echo "${GREEN}$count. $eachchkservice - PASSED ($eachchkservice is not active) ${NC}"

			((count++))

		else 

			echo "${RED}$count. $eachchkservice - FAILED ($eachchkservice is active)${NC}"

			((count++))

		fi

	fi

done



printf "\n"

printf "Special Purpose Services\n"



checkumask=`grep ^umask /etc/sysconfig/init`



if [ "$checkumask" == "umask 027" ]

then 

	echo "${GREEN}1. Umask - PASSED (umask is set to 027)${NC}"

else 

	echo "${RED}1. Umask - FAILED (umask is not set to 027)${NC}"

fi



checkxsystem=`ls -l /etc/systemd/system/default.target | grep graphical.target` #Must return empty

checkxsysteminstalled=`rpm  -q xorg-x11-server-common`	#Must return something

	

if [ -z "$checkxsystem" -a -z "$checkxsysteminstalled" ]

then 

	echo "${RED}2. X Window System - FAILED (Xorg-x11-server-common is installed)${NC}"

elif [ -z "$checkxsystem" -a -n "$checkxsysteminstalled" ]

then

	echo "${GREEN}2. X Window System - PASSED (Xorg-x11-server-common is not installed and is not the default graphical interface)${NC}"

elif [ -n "$checkxsystem" -a -z "$checkxsysteminstalled" ]

then

	echo "${RED}2. X Window System - FAILED (Xorg-x11-server-common is not installed and is the default graphical interface)${NC}"

else 

	echo "${RED}2. X Window System - FAILED (Xorg-x11-server-common is installed and is the default graphical interface)${NC}"

fi

count=3

	checkavahi=`systemctl status avahi-daemon | grep inactive`

	checkavahi1=`systemctl status avahi-daemon | grep disabled`

	if [ -n "$checkavahi" -a -n "$checkavahi1" ]

	then 

		echo "${GREEN}$count. Avahi-daemon - PASSED (Avahi-daemon is inactive and disabled) ${NC}"

		((count++))

	elif [ -n "$checkavahi" -a -z "$checkavahi1" ]

	then 

		echo "${RED}$count. Avahi-daemon - FAILED (Avahi-daemon is inactive but not disabled)${NC}"

		((count++))

	elif [ -z "$checkavahi" -a -n "$checkavahi1" ]

	then 

		echo "${RED}$count. Avahi-daemon - FAILED (Avahi-daemon is disabled but active)${NC}"

		((count++))

	else 

		echo "${RED}$count. Avahi-daemon - FAILED (Avahi-daemon is active and enabled)${NC}"

		((count++))

	fi

	

	checkcups=`systemctl status cups | grep inactive`

	checkcups1=`systemctl status cups | grep disabled`

	

if [ -n "$checkcups" -a -n "$checkcups1" ]

	then 

		echo "${GREEN}$count. Cups - PASSED (Cups is inactive and disabled) ${NC}"

		((count++))

	elif [ -n "$checkcups" -a -z "$checkcups1" ]

	then 

		echo "${RED}$count. Cups - FAILED (Cups is inactive but not disabled)${NC}"

		((count++))

	elif [ -z "$checkcups" -a -n "$checkcups1" ]

	then 

		echo "${RED}$count. Cups - FAILED (Cups is disabled but active)${NC}"

		((count++))

	else 

		echo "${RED}$count. Cups - FAILED (Cups is active and enabled)${NC}"

		((count++))

	fi





checkyumdhcp=`yum list dhcp | grep "Available Packages" `

checkyumdhcpactive=`systemctl status dhcp | grep inactive `

checkyumdhcpenable=`systemctl status dhcp | grep disabled `

if [ -n "$checkyumdhcp" ]

then 

	echo "$count. DHCP Server - PASSED (DHCP is not installed) "

	((count++))

else 

	if [ -z "$checkyumdhcpactive" -a -z "$checkyumdhcpenable" ]

	then 

		echo "${RED}$count. DHCP - FAILED (DHCP is active and enabled)${NC}"

		((count++))

	elif [ -z "$checkyumdhcpactive" -a -n "$checkyumdhcpenable" ]

	then 

		echo "${RED}$count. DHCP - FAILED (DHCP is active but disabled)${NC}"

		((count++))

	elif [ -n "$checkyumdhcpactive" -a -z "$checkyumdhcpenable" ]

	then

		echo "${RED}$count. DHCP - FAILED (DHCP is inactive but enabled)${NC}"

		((count++))

	else 

		echo "${RED}count. DHCP - FAILED (DHCP is inactive but disabled)${NC}"

		((count++))

	fi

fi



checkntp1=`grep "^restrict default kod nomodify notrap nopeer noquery" /etc/ntp.conf`

checkntp2=`grep "^restrict -6 default kod nomodify notrap nopeer noquery" /etc/ntp.conf` 

checkntp3=`grep "^server" /etc/ntp.conf | grep server`

checkntp4=`grep 'OPTIONS="-u ntp:ntp -p /var/run/ntpd.pid"' /etc/sysconfig/ntpd `



if [ -n "$checkntp1" ]

then 

	if [ -n "$checkntp2" ]

	then 

		if [ -n "$checkntp3" ]

			then 

				if [ -n "$checkntp4" ]

				then

					echo "${GREEN}$count. NTP - PASSED (NTP has been properly configured)${NC}"

					((count++))

				else 

					echo "${RED}$count. NTP - FAILED (Option has not been configured in /etc/sysconfig/ntpd)${NC}" 

					((count++))

				fi

		else

			echo "${RED}$count. NTP - FAILED (Failed to list down NTP servers)${NC}"

			((count++))

		fi

	else 

		echo "${RED}$count. NTP - FAILED (Failed to implement restrict -6 default kod nomodify notrap nopeer noquery)${NC}"

		((count++))

	fi

else 

	echo "${RED}$count. NTP - FAILED (Failed to implement restrict default kod nomodify notrap nopeer noquery)${NC}"

	((count++))

fi 



checkldapclients=`yum list openldap-clients | grep 'Available Packages'`

checkldapservers=`yum list openldap-servers | grep 'Available Packages'`



if [ -n "checkldapclients" -a -n "checkldapservers" ]

then 

	echo "${GREEN}$count. LDAP - PASSED (LDAP server and client are both not installed)$NC}"

	((count++))

elif [ -n "checkldapclients" -a -z "checkldapservers" ]

then

	echo "${RED}$count. LDAP - FAILED (LDAP server is installed)${NC}"

	((count++))

elif [ -z "checkldapclients" -a -n "checkldapservers" ]

then

	echo "${RED}$count. LDAP - FAILED (LDAP client is installed)${NC}"

	((count++))

else 

	echo "${RED}$count. LDAP - FAILED (Both LDAP client and server are installed)${NC}"

	((count++))

fi 



nfsservices=( "nfs-lock" "nfs-secure" "rpcbind" "nfs-idmap" "nfs-secure-server" )



for eachnfsservice in ${nfsservices[*]}

do 

	checknfsservices=`systemctl is-enabled $eachnfsservice | grep enabled`

	if [ -z "$checknfsservices" ]

	then 

		echo "${GREEN}$count. $eachnfsservice - PASSED ($eachnfsservice is disabled) ${NC}"

		((count++))

	else 

		echo "${RED}$count. $eachnfsservice - FAILED ($eachnfsservice is enabled)${NC}"

		((count++))

	fi

done 	



standardservices=( "named" "vsftpd" "httpd" "sshd" "snmpd") 





for eachstandardservice in ${standardservices[*]}

do 

	checkserviceexist=`systemctl status $eachstandardservice | grep not-found`

	if [ -n "$checkserviceexist" ]

	then

		echo "${GREEN}$count. $eachstandardservice - PASSED ($eachstandardservice does not exist in the system)${NC}"

		((count++))

	else

		checkstandardservices=`systemctl status $eachstandardservice | grep disabled`

		checkstandardservices1=`systemctl status $eachstandardservice | grep inactive`

		if [ -z "$checkstandardservices" -a -z "$checkstandardservices1" ]

		then 

			echo "${RED}$count. $eachstandardservice - FAILED ($eachstandardservice is active and enabled) ${NC}"

			((count++))

		elif [ -z "$checkstandardservices" -a -n "$checkstandardservices1" ]

		then 

			echo "${RED}$count. $eachstandardservice - FAILED ($eachstandardservice is inactive but enabled) ${NC}"

			((count++))

		elif [ -n "$checkstandardservices" -a -z "$checkstandardservices1" ]

		then 

			echo "${RED}$count. $eachstandardservice - FAILED ($eachstandardservice is disabled but active) ${NC}"

			((count++))

		else 

			echo "${GREEN}$count. $eachstandardservice - PASSED ($eachstandardservice is disabled and inactive) ${NC}"

			((count++))

		fi

	fi

done 	



checkmailtransferagent=`netstat -an | grep ":25[[:space:]]"`



if [ -n "$checkmailtransferagent" ]

then

	checklistening=`netstat -an | grep LISTEN`

	if [ -n "$checklistening" ]

	then

		checklocaladdress=`netstat -an | grep [[:space:]]127.0.0.1:25[[:space:]] | grep LISTEN`

		if [ -n "$checklocaladdress" ]

		then

			echo "${GREEN}$count. MTA - PASSED (Mail Transfer Agent is listening on the loopback address)${NC}"

		else

			echo "${RED}$count. MTA - FAILED (Mail Transfer Agent is not listening on the loopback address)${NC}"

		fi

	else

		echo "${RED}$count. MTA - FAILED (Mail Transfer Agent is not in listening mode)${NC}"

	fi

else

	echo "${RED}$count. MTA - FAILED (Mail Transfer Agent is not configured/installed)${NC}"

fi



####################################### 4.1 to 6.2.1.9 ######################################



#To stop “Control-C”

trap '' 2



#To stop “Control-Z”

trap '' SIGTSTP



printf "\n"



# 4.1 and 4.2

echo -e "\e[4m ${bold}4.1 and 4.2 : Set User/Group Owner and Permissions on /boot/grub2/grub.cfg\e[0m\n ${normal}"

checkgrubowner=`stat -L -c "owner=%U group=%G" /boot/grub2/grub.cfg`



if  [ "$checkgrubowner" == "owner=root group=root" ]

then

	checkgrubpermission=`stat -L -c "%a" /boot/grub2/grub.cfg | cut -b 2,3`



	if [ "$checkgrubpermission" == "00" ]

	then

		echo "${GREEN}/boot/grub2/grub.cfg - PASSED (Owner, group owner and permission of file is configured correctly)${NC}"



	else

		echo "${RED}/boot/grub2/grub.cfg - FAILED (Permission of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/boot/grub2/grub.cfg - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

fi



printf "\n\n"



# 4.3

echo -e "\e[4m ${bold}4.3 : Set Boot Loader Password\e[0m\n ${normal}"

checkbootloaderuser=`grep "^set superusers" /boot/grub2/grub.cfg`



if [ -z "$checkbootloaderuser" ]

then

	echo "${RED}Boot Loader Password - FAILED (Boot loader is not configured with any superuser)${NC}"



else

	checkbootloaderpassword=`grep "^passwd" /boot/grub2/grub.cfg`



	if [ -z "$checkbootloaderpassword" ]

	then

		echo "${RED}Boot Loader Password - FAILED (Boot loader is not configured with a password)${NC}"



	else

		echo "${GREEN}Boot Loader Password - PASSED (Boot loader is configured with a superuser and password)${NC}"

	fi



fi	



printf "\n\n"

# 5.1

echo -e "\e[4m ${bold}5.1 : Restrict Core Dumps\e[0m\n ${normal}"

checkcoredump=`grep "hard core" /etc/security/limits.conf`

coredumpval="* hard core 0"



if [ "$checkcoredump" == "$coredumpval" ]

then

	checksetuid=`sysctl fs.suid_dumpable`

	setuidval="fs.suid_dumpable = 0"



	if [ "$checksetuid" == "$setuidval" ]

	then

		echo "${GREEN}Core Dump - PASSED (Core dumps are restricted and setuid programs are prevented from dumping core)${NC}"



	else

		echo "${RED}Core Dump - FAILED (Setuid programs are not prevented from dumping core)${NC}"

	fi



else

	echo "${RED}Core Dump - FAILED (Core dumps are not restricted)${NC}"

fi



printf "\n\n"



# 5.2

echo -e "\e[4m ${bold}5.2 : Enable Randomized Virtual Memory Region Placement\e[0m\n ${normal}"

checkvirtualran=`sysctl kernel.randomize_va_space`

virtualranval="kernel.randomize_va_space = 2"



if [ "$checkvirtualran" == "$virtualranval" ]

then

	echo "${GREEN}Randomized Virtual Memory Region Placement - PASSED (Virtual memory is randomized) ${NC}"



else

	echo "${RED}Randomized Virtual Memory Region Placement - FAILED (Virtual memory is not randomized)${NC}"

fi



printf "\n\n"



# 6.1

echo '${bold}'

printf "============================================================================\n"

printf "6.1 : Configure rsyslog\n"

printf "============================================================================\n"

printf "\n"

echo '${normal}'



# 6.1.1 and 6.1.2

echo -e "\e[4m ${bold}6.1.1 and 6.1.2 : Install the rsyslogpackage and Activate the rsyslog Service\e[0m\n $[normal}"

checkrsyslog=`rpm -q rsyslog | grep "^rsyslog"`

if [ -n "$checkrsyslog" ]

then

	checkrsysenable=`systemctl is-enabled rsyslog`



	if [ "$checkrsysenable" == "enabled" ]

	then

		echo "${GREEN}Rsyslog - PASSED (Rsyslog is installed and enabled) ${NC}"



	else

		echo "${RED}Rsyslog - FAILED (Rsyslog is disabled)${NC}"

	fi



else

	echo "${RED}Rsyslog - FAILED (Rsyslog is not installed) ${RED}"

fi



printf "\n\n"



# 6.1.3

echo -e "\e[4m ${bold}6.1.3 and 6.1.4 : Configure /etc/rsyslog.conf and Create and Set Permissions on rsyslog Log Files\e[0m\n ${normal}"

checkvarlogmessageexist=`ls -l /var/log/ | grep messages`



if [ -n "$checkvarlogmessageexist" ]

then

	checkvarlogmessageown=`ls -l /var/log/messages | cut -d ' ' -f3,4`



	if [ "$checkvarlogmessageown" == "root root" ]

	then

		checkvarlogmessagepermit=`ls -l /var/log/messages | cut -d ' ' -f1`



		if [ "$checkvarlogmessagepermit" == "-rw-------." ]

		then

			checkvarlogmessage=`grep /var/log/messages /etc/rsyslog.conf`



			if [ -n "$checkvarlogmessage" ]

			then

				checkusermessage=`grep /var/log/messages /etc/rsyslog.conf | grep "^auth,user.*"`



				if [ -n "$checkusermessage" ]

				then

					echo "${GREEN}/var/log/messages - PASSED (Owner, group owner, permissions, facility are configured correctly; messages logging is set)${NC}"



				else

					echo "${RED}/var/log/messages - FAILED (Facility is not configured correctly)${NC}"

				fi



			else

				echo "${RED}/var/log/messages - FAILED (messages logging is not set)${NC}"

			fi



		else

			echo "${RED}/var/log/messages - FAILED (Permissions of file is configured incorrectly)${NC}"

		fi



	else

		echo "${RED}/var/log/messages - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/var/log/messages - FAILED (/var/log/messages file does not exist)${NC}"

fi



printf "\n"



checkvarlogkernexist=`ls -l /var/log/ | grep kern.log`



if [ -n "$checkvarlogkernexist" ]

then

	checkvarlogkernown=`ls -l /var/log/kern.log | cut -d ' ' -f3,4`



	if [ "$checkvarlogkernown" == "root root" ]

	then

		checkvarlogkernpermit=`ls -l /var/log/kern.log | cut -d ' ' -f1`



		if [ "$checkvarlogkernpermit" == "-rw-------." ]

		then

			checkvarlogkern=`grep /var/log/kern.log /etc/rsyslog.conf`



			if [ -n "$checkvarlogkern" ]

			then

				checkuserkern=`grep /var/log/kern.log /etc/rsyslog.conf | grep "^kern.*"`



				if [ -n "$checkuserkern" ]

				then

					echo "${GREEN}/var/log/kern.log - PASSED (Owner, group owner, permissions, facility are configured correctly; kern.log logging is set) ${NC}"



				else

					echo "${RED}/var/log/kern.log - FAILED (Facility is not configured correctly)${NC}"

				fi



			else

				echo "${RED}/var/log/kern.log - FAILED (kern.log logging is not set)${NC}"

			fi



		else

			echo "${RED}/var/log/kern.log - FAILED (Permissions of file is configured incorrectly)${NC}"

		fi



	else

		echo "${RED}/var/log/kern.log - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/var/log/kern.log - FAILED (/var/log/kern.log file does not exist)${NC}"

fi



printf "\n"



checkvarlogdaemonexist=`ls -l /var/log/ | grep daemon.log`



if [ -n "$checkvarlogdaemonexist" ]

then

	checkvarlogdaemonown=`ls -l /var/log/daemon.log | cut -d ' ' -f3,4`



	if [ "$checkvarlogdaemonown" == "root root" ]

	then

		checkvarlogdaemonpermit=`ls -l /var/log/daemon.log | cut -d ' ' -f1`



		if [ "$checkvarlogdaemonpermit" == "-rw-------." ]

		then

			checkvarlogdaemon=`grep /var/log/daemon.log /etc/rsyslog.conf`



			if [ -n "$checkvarlogdaemon" ]

			then

				checkuserdaemon=`grep /var/log/daemon.log /etc/rsyslog.conf | grep "^daemon.*"`



				if [ -n "$checkuserdaemon" ]

				then

					echo "${GREEN}/var/log/daemon.log - PASSED (Owner, group owner, permissions, facility are configured correctly; daemon.log logging is set)${NC}"



				else

					echo "${RED}/var/log/daemon.log - FAILED (Facility is not configured correctly)${NC}"

				fi



			else

				echo "${RED}/var/log/daemon.log - FAILED (daemon.log logging is not set)${NC}"

			fi



		else

			echo "${RED}/var/log/daemon.log - FAILED (Permissions of file is configured incorrectly)${NC}"

		fi



	else

		echo "${RED}/var/log/daemon.log - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/var/log/daemon.log - FAILED (/var/log/daemon.log file does not exist)${NC}"

fi



printf "\n"



checkvarlogsyslogexist=`ls -l /var/log/ | grep syslog.log`



if [ -n "$checkvarlogsyslogexist" ]

then

	checkvarlogsyslogown=`ls -l /var/log/syslog.log | cut -d ' ' -f3,4`



	if [ "$checkvarlogsyslogown" == "root root" ]

	then

		checkvarlogsyslogpermit=`ls -l /var/log/syslog.log | cut -d ' ' -f1`



		if [ "$checkvarlogsyslogpermit" == "-rw-------." ]

		then

			checkvarlogsyslog=`grep /var/log/syslog.log /etc/rsyslog.conf`



			if [ -n "$checkvarlogsyslog" ]

			then

				checkusersyslog=`grep /var/log/syslog.log /etc/rsyslog.conf | grep "^syslog.*"`



				if [ -n "$checkusersyslog" ]

				then

					echo "${GREEN}/var/log/syslog.log - PASSED (Owner, group owner, permissions, facility are configured correctly; syslog.log logging is set)${NC}"



				else

					echo "${RED}/var/log/syslog.log - FAILED (Facility is not configured correctly)${NC}"

				fi



			else

				echo "${RED}/var/log/syslog.log - FAILED (syslog.log logging is not set)${NC}"

			fi



		else

			echo "${RED}/var/log/syslog.log - FAILED (Permissions of file is configured incorrectly)${NC}"

		fi



	else

		echo "${RED}/var/log/syslog.log - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/var/log/syslog.log - FAILED (/var/log/syslog.log file does not exist)${NC}"

fi



printf "\n"



checkvarlogunusedexist=`ls -l /var/log/ | grep unused.log`



if [ -n "$checkvarlogunusedexist" ]

then

	checkvarlogunusedown=`ls -l /var/log/unused.log | cut -d ' ' -f3,4`



	if [ "$checkvarlogunusedown" == "root root" ]

	then

		checkvarlogunusedpermit=`ls -l /var/log/unused.log | cut -d ' ' -f1`



		if [ "$checkvarlogunusedpermit" == "-rw-------." ]

		then

			checkvarlogunused=`grep /var/log/unused.log /etc/rsyslog.conf`



			if [ -n "$checkvarlogunused" ]

			then

				checkuserunused=`grep /var/log/unused.log /etc/rsyslog.conf | grep "^lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*"`



				if [ -n "$checkuserunused" ]

				then

					echo "${GREEN}/var/log/unused.log - PASSED (Owner, group owner, permissions, facility are configured correctly; unused.log logging is set)${NC}"



				else

					echo "${RED}/var/log/unused.log - FAILED (Facility is not configured correctly)${NC}"

				fi



			else

				echo "${RED}/var/log/unused.log - FAILED (unused.log logging is not set)${NC}"

			fi



		else

			echo "${RED}/var/log/unused.log - FAILED (Permissions of file is configured incorrectly)${NC}"

		fi



	else

		echo "${RED}/var/log/unused.log - FAILED (Owner and group owner of file is configured incorrectly)${NC}"

	fi



else

	echo "${RED}/var/log/unused.log - FAILED (/var/log/unused.log file does not exist)${NC}"

fi



printf "\n\n"



# 6.1.5

echo -e "\e[4m ${bold}6.1.5 : Configure rsyslogto Send Logs to a Remote Log Host\e[0m\n $[normal}"

checkloghost=$(grep "^*.*[^|][^|]*@" /etc/rsyslog.conf)

if [ -z "$checkloghost" ]  # If there is no log host

then

	printf "${RED}Remote Log Host : FAILED (Remote log host has not been configured)\n ${NC}"

else

	printf "${GREEN}Remote Log Host : PASSED (Remote log host has been configured)\n ${NC}"

fi



printf "\n\n"

# 6.1.6

echo -e "\e[4m ${bold}6.1.6 : Accept Remote rsyslog Messages Only on Designated Log Hosts\e[0m\n ${normal}"

checkrsysloglis=`grep '^$ModLoad imtcp.so' /etc/rsyslog.conf`

checkrsysloglis1=`grep '^$InputTCPServerRun' /etc/rsyslog.conf`



if [ -z "$checkrsysloglis" -o -z "$checkrsysloglis1" ]

then

	echo "${RED}Remote rsyslog - FAILED (Rsyslog is not listening for remote messages)${NC}"



else

	echo "${GREEN}Remote rsyslog - PASSED (Rsyslog is listening for remote messages)${NC}"

fi



printf "\n\n"

echo '${bold}}'

printf "============================================================================\n"

printf "6.2 : Configure System Accounting\n"

printf "============================================================================\n"

printf "\n"

echo "----------------------------------------------------------------------------"

printf "6.2.1 : Configure Data Retention\n"

echo "----------------------------------------------------------------------------"

printf "\n"

echo '${normal}'



# 6.2.1.1

echo -e "\e[4m ${bold}6.2.1.1 : Configure Audit Log Storage Size\e[0m\n ${normal}"

checklogstoragesize=`grep max_log_file[[:space:]] /etc/audit/auditd.conf | awk '{print $3}'`



if [ "$checklogstoragesize" == 5 ]

then

	echo "${GREEN}Audit Log Storage Size - PASSED (Maximum size of audit log files is configured correctly)${NC}"



else

	echo "${RED}Audit Log Storage Size - FAILED (Maximum size of audit log files is not configured correctly)${NC}"

fi



printf "\n\n"



# 6.2.1.2

echo -e "\e[4m ${bold}6.2.1.2 : Keep All Auditing Information\e[0m\n ${normal}"

checklogfileaction=`grep max_log_file_action /etc/audit/auditd.conf | awk '{print $3}'`

 

if [ "$checklogfileaction" == keep_logs ]

then

	echo "${GREEN}Audit Log File Action - PASSED (Action of the audit log file is configured correctly)${NC}"



else

	echo "${RED}Audit Log File Action - FAILED (Action of the audit log file is not configured correcly)${NC}"

fi



printf "\n\n"



# 6.2.1.3

echo -e "\e[4m ${bold}6.2.1.3 : Disable System on Audit Log Full\e[0m\n ${normal}"

checkspaceleftaction=`grep space_left_action /etc/audit/auditd.conf | grep "email"`



if [ -n "$checkspaceleftaction" ]

then

	checkactionmailacc=`grep action_mail_acct /etc/audit/auditd.conf | awk '{print $3}'`

	if [ "$checkactionmailacc" == root ]

	then

		checkadminspaceleftaction=`grep admin_space_left_action /etc/audit/auditd.conf | awk '{print $3}'`

		if [ "$checkadminspaceleftaction" == halt ]

		then

			echo "${GREEN}Disable System - PASSED (Auditd is correctly configured to notify the administrator and halt the system when audit logs are full)${NC}"

		else

			echo "${RED}Disable System - FAILED (Auditd is not configured to halt the system when audit logs are full)${NC}"

		fi



	else

		echo "${RED}Disable System - FAILED (Auditd is not configured to notify the administrator when audit logs are full)${NC}"

	fi

	

else

	echo "${RED}Disable System - FAILED (Auditd is not configured to notify the administrator by email when audit logs are full)${NC}"

fi



printf "\n\n"



# 6.2.1.4

echo -e "\e[4m ${bold}6.2.1.4 : Enable auditd Service\e[0m\n ${normal}"

checkauditdservice=`systemctl is-enabled auditd`



if [ "$checkauditdservice" == enabled ]

then

	echo "${GREEN}Auditd Service - PASSED (Auditd is enabled)${NC}"



else

	echo "${RED}Auditd Service - FAILED (Auditd is not enabled)${NC}"

fi



printf "\n\n"



# 6.2.1.5

echo -e "\e[4m ${bold}6.2.1.5 : Enable Auditing for Processes That Start Prior to auditd\e[0m\n ${normal}"

checkgrub=$(grep "linux" /boot/grub2/grub.cfg | grep "audit=1") 

if [ -z "$checkgrub" ]

then

	printf "${RED}System Log Processes : FAILED (System is not configured to log processes that start prior to auditd\n ${NC}"



else

	printf "${GREEN}System Log Processes : PASSED (System is configured to log processes that start prior to auditd\n ${NC}"

fi



printf "\n\n"



# 6.2.1.6

echo -e "\e[4m ${bold}6.2.1.6 : Record Events That Modify Date and Time Information\e[0m\n ${normal}"

checksystem=`uname -m | grep "64"`

checkmodifydatetimeadjtimex=`egrep 'adjtimex|settimeofday|clock_settime' /etc/audit/audit.rules`



if [ -z "$checksystem" ]

then

	echo "It is a 32-bit system."

	printf "\n"

	if [ -z "$checkmodifydatetimeadjtimex" ]

	then

        echo "${RED}Date & Time Modified Events - FAILED (Events where system date and/or time has been modified are not captured)${NC}"



	else

		echo "${GREEN}Date & Time Modified Events - PASSED (Events where system date and/or time has been modified are captured)${NC}"

	fi



else

	echo "It is a 64-bit system."

	printf "\n" 

	if [ -z "$checkmodifydatetimeadjtimex" ]

	then

        echo "${RED}Date & Time Modified Events - FAILED (Events where system date and/or time has been modified are not captured)${NC}"



	else

		echo "${GREEN}Date & Time Modified Events - PASSED (Events where system date and/or time has been modified are captured)${NC}"

	fi



fi



printf "\n\n"



# 6.2.1.7

echo -e "\e[4m ${bold}6.2.1.7 : Record Events That Modify User/Group Information\e[0m\n ${normal}"

checkmodifyusergroupinfo=`egrep '\/etc\/group' /etc/audit/audit.rules`



if [ -z "$checkmodifyusergroupinfo" ]

then

        echo "${RED}Group Configuration - FAILED (Group is not configured)${NC}"



else

        echo "${GREEN}Group Configuration - PASSED (Group is already configured)${NC}"

fi



printf "\n"



checkmodifyuserpasswdinfo=`egrep '\/etc\/passwd' /etc/audit/audit.rules`



if [ -z "$checkmodifyuserpasswdinfo" ]

then

        echo "${RED}Password Configuration - FAILED (Password is not configured)${NC}"



else

        echo "${GREEN}Password Configuration - PASSED (Password is configured)${NC}"

fi



printf "\n"



checkmodifyusergshadowinfo=`egrep '\/etc\/gshadow' /etc/audit/audit.rules`



if [ -z "$checkmodifyusergshadowinfo" ]

then

        echo "${RED}GShadow Configuration - FAILED (GShadow is not configured)${NC}"



else

        echo "${GREEN}GShadow Configuration - PASSED (GShadow is configured)${NC}"

fi



printf "\n"



# 6.2.1.8

checkmodifyusershadowinfo=`egrep '\/etc\/shadow' /etc/audit/audit.rules`



if [ -z "$checkmodifyusershadowinfo" ]

then

        echo "${RED}Shadow Configuration - FAILED (Shadow is not configured)${NC}"



else

        echo "{GREEN}Shadow Configuration - PASSED (Shadow is configured)${NC}"

fi



printf "\n"



checkmodifyuseropasswdinfo=`egrep '\/etc\/security\/opasswd' /etc/audit/audit.rules`



if [ -z "$checkmodifyuseropasswdinfo" ]

then

        echo "${RED}OPasswd Configuration- FAILED (OPassword not configured)${NC}"



else

        echo "${GREEN}OPasswd Configuration - PASSED (OPassword is configured)${NC}"

fi



printf "\n\n"



# 6.2.1.8

echo -e "\e[4m ${bold}6.2.1.8 : Record Events That Modify the System's Network Environment\e[0m\n ${normal}"

checksystem=`uname -m | grep "64"`

checkmodifynetworkenvironmentname=`egrep 'sethostname|setdomainname' /etc/audit/audit.rules`



if [ -z "$checksystem" ]

then

	echo "It is a 32-bit system."

	printf "\n"

	if [ -z "$checkmodifynetworkenvironmentname" ]

	then

        	echo "${RED}Modify the System's Network Environment Events - FAILED (Sethostname and setdomainname is not configured)${NC}"



	else

		echo "${GREEN}Modify the System's Network Environment Events - PASSED (Sethostname and setdomainname is configured)${NC}"

	fi



else

	echo "It is a 64-bit system."

	printf "\n"

	if [ -z "$checkmodifynetworkenvironmentname" ]

	then

        echo "${RED}Modify the System's Network Environment Events - FAILED (Sethostname and setdomainname is not configured)${NC}"



	else

		echo "${GREEN}Modify the System's Network Environment Events - PASSED (Sethostname and setdomainname is configured${NC}"

	fi



fi



printf "\n"



checkmodifynetworkenvironmentissue=`egrep '\/etc\/issue' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmentissue" ]

then

    echo "${RED}Modify the System's Network Environment Events - FAILED (/etc/issue is not configured)${NC}"



else

    echo "${GREEN}Modify the System's Network Environment Events - PASSED (/etc/issue is configured)${NC}"

fi



printf "\n"



checkmodifynetworkenvironmenthosts=`egrep '\/etc\/hosts' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmenthosts" ]

then

    echo "${RED}Modify the System's Network Environment Events - FAILED (/etc/hosts is not configured)${NC}"



else

     echo "${GREEN}Modify the System's Network Environment Events - PASSED (/etc/hosts is configured)${NC}"

fi



printf "\n"



checkmodifynetworkenvironmentnetwork=`egrep '\/etc\/sysconfig\/network' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmentnetwork" ]

then

    echo "${RED}Modify the System's Network Environment Events - FAILED (/etc/sysconfig/network is not configured)${NC}"



else

    echo "${GREEN}Modify the System's Network Environment Events - PASSED (/etc/sysconfig/network is configured)${NC}"

fi



printf "\n\n"

# 6.2.1.9

echo -e "\e[4m ${bold}6.2.1.9 : Record Events That Modify the System's Mandatory Access Controls\e[0m\n ${normal}"

checkmodifymandatoryaccesscontrol=`grep \/etc\/selinux /etc/audit/audit.rules`



if [ -z "$checkmodifymandatoryaccesscontrol" ]

then

	echo "${RED}Modify the System's Mandatory Access Controls Events - FAILED (Recording of modified system's mandatory access controls events is not configured)${NC}"



else

	echo "${GREEN}Modify the System's Mandatory Access Controls Events - PASSED (Recording of modified system's mandatory access controls events is configured)${NC}"

fi



printf "\n\n"



# Force exit

read -n 1 -s -r -p "Press any key to exit!"

kill -9 $PPID

####################################### 6.2.1.10 to 6.2.1.21 ######################################



#6.2.1.10

echo "${bold}6.2.1.10 Collect Login and Logout Events${normal}"

chklogins=`grep logins /etc/audit/audit.rules`

loginfail=`grep "\-w /var/log/faillog -p wa -k logins" /etc/audit/audit.rules`

loginlast=`grep "\-w /var/log/lastlog -p wa -k logins" /etc/audit/audit.rules`

logintally=`grep "\-w /var/log/tallylog -p wa -k logins" /etc/audit/audit.rules`



if [ -z "$loginfail" -o -z "$loginlast" -o -z "$logintally" ]

then

        echo "${RED}FAILED - Login and logout events not recorded.${NC}"

else

        echo "${GREEN}PASSED - Login and logout events recorded.${NC}"

fi



#6.2.1.11

echo "${bold}6.2.1.11 Collect Session Initiation Information${normal}"

chksession=`egrep 'wtmp|btmp|utmp' /etc/audit/audit.rules`

sessionwtmp=`egrep "\-w /var/log/wtmp -p wa -k session" /etc/audit/audit.rules`

sessionbtmp=`egrep "\-w /var/log/btmp -p wa -k session" /etc/audit/audit.rules`

sessionutmp=`egrep "\-w /var/run/utmp -p wa -k session" /etc/audit/audit.rules`



if [ -z "$sessionwtmp" -o -z "$sessionbtmp" -o -z "sessionutmp" ]

then

        echo "${RED}FAILED - Session initiation information not collected.${NC}"

else

        echo "${GREEN}PASSED - Session initiation information is collected.${NC}"

fi



#6.2.1.12

echo "${bold}6.2.1.12 Collect Discretionary Access Control Permission Modification Events${normal}"

chkpermission64=`grep perm_mod /etc/audit/audit.rules`

permission1=`grep "\-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`

permission2=`grep "\-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F

auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`

permission3=`grep "\-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S|chown -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`

permission4=`grep "\-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S|chown -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`

permission5=`grep "\-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -Fauid!=4294967295 -k perm_mod" /etc/audit/audit.rules`

permission6=`grep "\-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S

 fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F

auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



if [ -z "$permission1" -o -z "$permission2" -o -z permission3 -o -z permission4 -o -z permission5 -o -z permission6 ]

then

        echo "${RED}FAILED - Permission modifications not recorded.${NC}"



else

        echo "${GREEN}PASSED - Permission modification are recorded.${NC}"

fi



#6.2.1.13

echo "${bold}6.2.1.13 Collect Unsuccesful Unauthorised Access Attempts to Files ${normal}"

chkaccess=`grep access /etc/audit/audit.rules`

access1=`grep "\-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`

access2=`grep "\-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`

access3=`grep "\-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`

access4=`grep "\-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`

access5=`grep "\-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`

access6=`grep "\-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



if [ -z "$access1" -o -z "$access2" -o -z "$access3" -o -z "$access4" -o -z "$access5" -o -z "$access6" ]

then

        echo "${RED}FAILED - Unsuccesful attempts to access files.${NC}"



else

        echo "${GREEN}PASSED - Successful attempts to access files.${NC}"

fi



#6.2.1.14 Collect Use of Privileged Commands

echo "${bold}6.2.1.14 Collect Use of Privileged Commands${normal}"

find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print "-a always,exit-F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" }' > /tmp/1.log



checkpriviledge=`cat /tmp/1.log`

cat /etc/audit/audit.rules | grep -- "$checkpriviledge" > /tmp/2.log



checkpriviledgenotinfile=`grep -F -x -v -f /tmp/2.log /tmp/1.log`



if [ -n "$checkpriviledgenotinfile" ]

then

	echo "${RED}FAIL - Privileged Commands not in audit${NC}"

else

	echo "${GREEN}PASS - Privileged Commands in audit${NC}"

fi



rm /tmp/1.log

rm /tmp/2.log



#6.2.1.15 Collect Successful File System Mounts

echo "${bold}6.2.1.15 Collect Successful File System Mounts${normal}"

bit64mountb64=`grep "\-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`

bit64mountb32=`grep "\-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`

bit32mountb32=`grep "\-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`



if [ -z "$bit64mountb64" -o -z "$bit64mountb32" -o -z "$bit32mountb32" ]

then

	echo "${RED}FAIL - To determine filesystem mounts${NC}" 

else

	echo "${GREEN}PASS - To determine filesystem mounts${NC}"

fi



#6.2.1.16 Collect File Delection Events by User

echo "${bold}6.2.1.16 Collect File Delection Events by User ${normal}"

bit64delb64=`grep "\-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`

bit64delb32=`grep "\-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`

bit32delb32=`grep "\-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`



if [ -z "$bit64delb64" -o -z "$bit64delb32" -o -z "$bit32delb32" ]

then

	echo "${RED}FAIL - To determine the file delection event by user${NC}"

else

	echo "${GREEN}PASS - To determine the file delection event by user${NC}"

fi



#6.2.1.17 Collect Changes to System Administration Scope

echo "${bold} 6.2.1.17 Collect Changes to System Administration Scope${normal}"

chkscope=`grep scope /etc/audit/audit.rules`

sudoers='-w /etc/sudoers -p wa -k scope'



if [ -z "$chkscope" -o "$chkscope" != "$sudoers" ]

then

	echo "${RED}FAIL - To unauthorize change to scope of system administrator activity${NC}"

else

	echo "${GREEN}PASS - To unauthorize change to scope of system administrator activity${NC}"

fi



#6.2.1.18 

echo "${bold}6.2.1.18 Collect System Administrator Actions (sudolog)${normal}"

chkadminrules=`grep actions /etc/audit/audit.rules`

adminrules='-w /var/log/sudo.log -p wa -k actions'



if [ -z "$chkadminrules" -o "$chkadminrules" != "$adminrules" ]

then 

	echo "${RED}FAILED - Administrator activity not recorded${NC}"

else

	echo "${GREEN}PASSED - Administrator activity recorded${NC}"

fi



#6.2.1.19

echo "${bold}6.2.1.19 Collect Kernel Module Loading and Unloading ${normal}"

chkmod1=`grep "\-w /sbin/insmod -p x -k modules" /etc/audit/audit.rules`

chkmod2=`grep "\-w /sbin/rmmod -p x -k modules" /etc/audit/audit.rules`

chkmod3=`grep "\-w /sbin/modprobe -p x -k modules" /etc/audit/audit.rules`

chkmod4=`grep "\-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" /etc/audit/audit.rules`



if [ -z "$chkmod1" -o -z "$chkmod2" -o -z "$chkmod3" -o -z "$chkmod4" ]

then

	echo "${RED}FAILED - Kernel module not recorded${NC}"

else

	echo "${GREEN}PASSED - Kernel module recorded${NC}"

fi



#6.2.1.20

echo "${bold}6.2.1.20 Make the Audit Configuration Immutable${normal}"

chkimmute=`grep "^-e 2" /etc/audit/audit.rules`

immute='-e 2'



if [ -z "$chkimmute" -o "$chkimmute" != "$immute" ]

then

	echo "${RED}FAILED - Audit configuration is not immutable${NC}"

else

	echo "${GREEN}PASSED - Audit configuration immutable${NC}"

fi



#6.2.1.21

echo "${bold}6.2.1.21 Configure logrotate${normal}"

chkrotate1=`grep "/var/log/messages" /etc/logrotate.d/syslog`

chkrotate2=`grep "/var/log/secure" /etc/logrotate.d/syslog`

chkrotate3=`grep "/var/log/maillog" /etc/logrotate.d/syslog`

chkrotate4=`grep "/var/log/spooler" /etc/logrotate.d/syslog`

chkrotate5=`grep "/var/log/boot.log" /etc/logrotate.d/syslog`

chkrotate6=`grep "/var/log/cron" /etc/logrotate.d/syslog`



if [ -z "chkrotate1" -o -z "$chkrotate2" -o -z "$chkrotate3" -o -z "$chkrotate4" -o -z "$chkrotate5" -o -z "$chkrotate6" ]

then

	echo "${RED}FAILED - System logs not rotated${NC}"

else

	echo "${GREEN}PASSED - System logs recorded${NC}"

fi



####################################### 7.1 to 7.11 ######################################



echo "${bold}7.1 Set Password Expiration Days${normal}"



value=$(cat /etc/login.defs | grep "^PASS_MAX_DAYS" | awk '{ print $2 }')



standard=90 



if [ ! $value = $standard ]; then

  echo "${RED}Audit status: FAILED!${NC}"

elif [ $value = $standard ]; then

  echo "${GREEN}Audit status: PASSED!${NC}"

else

  echo "${RED}ERROR: FATAL ERROR, CONTACT SYSTEM ADMINISTRATOR!${RED}"

fi

#########################################################################

echo "${bold}7.2 Set Password Change Minimum Number of Days ${normal}"

value=$(cat /etc/login.defs | grep "^PASS_MIN_DAYS" | awk '{ print $2 }')



standard=7 



if [ ! $value = $standard ]; then

	echo "${RED}Audit status: FAILED!${NC}"

elif [ $value = $standard ]; then

	echo "${GREEN}Audit status: PASSED!${NC}"

else

	echo "${RED}ERROR: FATAL ERROR, CONTACT SYSTEM ADMINISTRATOR! ${NC}"

fi

#########################################################################

echo "${bold}7.3 Set Password Expiring Warning Days${normal}"

value=$(cat /etc/login.defs | grep "^PASS_WARN_AGE" | awk '{ print $2 }')



standard=7 



if [ ! $value = $standard ]; then

	echo "${RED}Audit status: FAILED!${NC}"

elif [ $value = $standard ]; then

	echo "${GREEN}Audit status: PASSED!{NC}"

else

	echo "${RED}ERROR: FATAL ERROR, CONTACT SYSTEM ADMINISTRATOR! ${NC}"

fi

#########################################################################

#7.4 Disable System Accounts



echo "${bold}7.4 Disable System Accounts${normal}"



current=$(egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/sbin/nologin" && $7!="/bin/false") { print $1 }')



if [ -z "$current" ]; then

	echo "${GREEN}Audit status: PASSED!${NC}"

elif [ ! -z "$current" ]; then

	echo "${RED}Audit status: FAILED!${NC}"

else

	echo "${RED}FATAL ERROR. PLEASE CONTACT YOUR SYSTEM ADMINISTRATOR!${NC}"

fi

#########################################################################

echo "${bold}7.5 Set Default Group for root Account${normal}"



current=$(grep "^root:" /etc/passwd | cut -f4 -d:)



if [ "$current" == 0 ]; then

        echo "${GREEN}Audit status: PASSED!${NC}"

else

        echo "${RED}Audit status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}7.6 Set Default umask for Users${normal}"



current=$(egrep -h "\s+umask ([0-7]{3})" /etc/bashrc /etc/profile | awk '{print $2}')



counter=0



for line in ${current}

do

	if [ "${line}" != "077" ] 

	then

       		((counter++))	

	fi

done



if [ ${counter} == 0 ]

then 

	echo "${GREEN}Audit status: PASSED!${NC}"

else     

	echo "${RED}Audit status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}7.7 Lock Inactive User Accounts${normal}"



current=$(useradd -D | grep INACTIVE | awk -F= '{print $2}')



if [ "${current}" -le 30 ] && [ "${current}" -gt 0 ]

then

        echo "${GREEN}Audit status: PASSED!${NC}"

else

        echo "${RED}Audit status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}7.8 Ensure Password Fields Are Not Empty${normal}"

current=$(cat /etc/shadow | awk -F: '($2 == "") { print $1 }')



if [ "$current" = "" ];then

	echo "${GREEN}Audit status: PASSED!${NC}"

else

	echo "${RED}Audit status: FAILED!${NC}" 

fi

#########################################################################

echo "${bold}7.9 Verify No Legacy "+" Entries Exist in /etc/passwd, /etc/shadow and /etc/group files${normal}"



passwd=$(grep '^+:' /etc/passwd) 

shadow=$(grep '^+:' /etc/shadow)

group=$(grep '^+:' /etc/group)



if [ "$passwd" == "" ]  && [ "$shadow" == "" ] && [ "$group" == "" ];then

	echo "${GREEN}Audit Status: PASSED!${NC}"

else

	echo "${RED}Audit Status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}7.10 Verify No UID 0 Accounts Exist Other Than Root${normal}"



current=$(/bin/cat /etc/passwd | /bin/awk -F: '($3 ==0) { print $1 }')



if [ "$current" = "root" ];then

	echo "${GREEN}Audit status: PASSED!${NC}"

else

	echo "${RED}Audit status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}7.11 Ensure root PATH Integrity${normal}"



check=0



#Check for Empty Directory in PATH (::)

if [ "`echo $PATH | grep ::`" != "" ]

then

	#echo "Empty Directory in PATH (::)"

	((check++))

fi



#Check for Trailing : in PATH

if [ "`echo $PATH | grep :$`" != "" ]

then

	#echo "Trailing : in PATH"

	((check++))

fi



p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`

set -- $p

while [ "$1" != "" ]

do

	#Check if PATH contains .

        if [ "$1" = "." ]

        then

		#echo "PATH contains ."

		((check++))

		shift

		continue

        fi

	

	#Check if PATH entry is a directory

        if [ -d $1 ]

        then

                dirperm=`ls -ldH $1 | cut -f1 -d" "`

                #Check if Group Write permission is set on directory

		if [ `echo $dirperm | cut -c6` != "-" ]

                then

			#echo "Group Write permission set on directory $1"

			((check++))

                fi

		#Check if Other Write permission is set on directory

                if [ `echo $dirperm | cut -c9` != "-" ]

		then

			#echo "Other Write permission set on directory $1"

			((check++))

                fi

		

		#Check if PATH entry is owned by root

                dirown=`ls -ldH $1 | awk '{print $3}'`

                if [ "$dirown" != "root" ]

                then

                       #echo $1 is not owned by root

			((check++))

                fi

        else

		#echo $1 is not a directory

		((check++))

        fi

	shift

done



#echo ${check}

if [ ${check} == 0 ]

then

	echo "${GREEN}Audit status: PASSED!${NC}"

elif [ ${check} != 0 ]

then

	echo "${RED}Audit status: FAILED!${NC}"

else

	echo "${RED}FATAL ERROR. PLEASE CONTACT YOUR SYSTEM ADMINISTRATOR!${NC}"

fi



####################################### 7.12 to 7.23 ######################################



GREEN="\033[0;32m"

RED="\033[0;31m"

NC="\033[0m"

bold=$(tput bold)

normal=$(tput sgr0)



####################################### 7.12 #######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.12 Check Permissions on User Home Directories${normal}"

echo ' '

intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"



if [ -z "$intUserAcc" ]

then

        echo "There is no interactive user account."

        echo ' '

else

        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do



                echo "Checking user home directory $line"

                permission="$(ls -ld $line)"

                echo " Permission is ${permission:0:10}"

                ## check 6th field ##

                if [ ${permission:5:1} == *"w"* ]

                then

                        echo -e "${RED} 6th field of permission is w ${NC}"

                else

                        echo -e "${GREEN} 6th field of permission is '-' ${NC}"

                fi



                ## check 8th field ##

                if [ ${permission:7:1} == "-" ]

                then

                        echo -e "${GREEN} 8th field of permission is '-' ${NC}"

                else

                        echo -e "${RED} 8th field of permission is not '-' ${NC}"

 fi



                ## check 9th field ##

                if [ ${permission:8:1} == "-" ]

                then

                        echo -e "${GREEN} 9th field of permission is '-' ${NC}"

                else

                        echo -e "${RED} 9th field of permission is not '-' ${NC}"

                fi



                ## check 10th field ##

                if [ ${permission:9:1} == "-" ]

                then

                        echo -e "${GREEN} 10th field of permission is '-' ${NC}"

                else

                        echo -e "${RED} 10th field of permission is not '-' ${NC}"

                fi

                echo " "

        done

fi



####################################### 7.13 #######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.13 Check User Dot File Permissions${normal}"

echo ' '



intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"



if [ -z "$intUserAcc" ]

then

        echo "There is no interactive user account."

        echo ' '

else

        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do



                echo "Checking hidden files in user home directory $line"

                cd $line

                hiddenfiles="$(echo .*)"



                if [ -z "$hiddenfiles" ]

                then

echo " There is no hidden files"

                else

                        for file in ${hiddenfiles[*]}

                        do

                                permission="$(stat -c %A $file)"

                                echo " Checking hidden file $file"

                                echo "  Permission is $permission"



                                ## check 6th field ##

                                if [ ${permission:5:1} == *"w"* ]

                                then

                                        echo -e " ${RED} 6th field of permission is 'w' ${NC}"

                                else

                                        echo -e " ${GREEN} 6th field of permission is not 'w' ${NC}"

                                fi



                                ## check 9th field ##

                                if [ ${permission:8:1} == *"w"* ]

                                then

                                        echo -e " ${RED} 9th field of permission is 'w' ${NC}"

                                else

                                        echo -e " ${GREEN} 9th field of permission is not 'w' ${NC}"

                                fi

 echo ' '

                        done

                fi

        done

fi



####################################### 7.14 #######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.14 Check Existence of and Permissions on User .netrc Files${normal}"

echo ' '

intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"



if [ -z "$intUserAcc" ]

then

        echo " There is no interactive user account."

        echo ' '

else

        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

 echo "Checking user home directory $line"

                permission="$(ls -al $line | grep .netrc)"

                if  [ -z "$permission" ]

                then

                        echo " There is no .netrc file"

                        echo ' '

                else

                        ls -al $line | grep .netrc | while read -r netrc; do

                                echo " $netrc"



                                ## check 5th field ##

                                if [ ${netrc:4:6} == "------" ]

                                then

                                        echo -e " ${GREEN} 5th-10th field of permission is '------' ${NC}"

                                else

                                        echo -e " ${RED} 5th-10th field of permission is not '------' ${NC}"

                                fi



                                echo ' '

                        done

                fi

        done

fi



#################################### 7.15 ####################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.15 Check for Presence of User .rhosts Files${normal}"

echo ' '



intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"



if [ -z "$intUserAcc" ]

then

        echo "There is no interactive user account."

        echo ' '

else

        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

                echo "Checking user home directory $line"

                rhostsfile="$(ls -al $line | grep .rhosts)"



 if  [ -z "$rhostsfile" ]

                then

                        echo " There is no .rhosts file"

                        echo ' '

                else

                        ls -al $line | grep .rhosts | while read -r rhosts; do

                                for file in $rhosts

                                do

                                        if [[ $file = *".rhosts"* ]]

                                        then

                                                echo " Checking .rhosts file $file"

                                                #check if file created user matches directory user

                                                filecreateduser=$(stat -c %U $line/$file)

                                                if [[ $filecreateduser = *"$line"* ]]

                                                then

                                                       echo -e "${GREEN} $file created user is the same user in the directory${NC}"



 echo ' '

                                                else

                                                        echo -e "${RED} $file created user is not the same in the directory. This file should be deleted! ${NC}"



 echo ' '

                                                fi

                                        fi

                                done                    

                        done

                fi

        done

fi



####################################### 7.16 ######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.16 Check Groups in /etc/passwd${normal}"

echo ' '



for i in $(cut -s -d: -f4 /etc/passwd | sort -u); do

	grep -q -P "^.*?:x:$i:" /etc/group

	if [ $? -ne 0 ]

	then

		echo -e "${RED}Group $i is referenced by /etc/passwd but does not exist in /etc/group${NC}"

	else

		echo -e "${GREEN}Group $i is referenced by /etc/passwd and exist in /etc/group${NC}"

	fi

done



####################################### 7.17 ######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.17 Check That Users Are Assigned Valid Home Directories && Home Directory Ownership is Correct${normal}"

echo ' '



cat /etc/passwd | awk -F: '{ print $1,$3,$6 }' | while read user uid dir; do



	#checking validity of  user assigned home directories

	if [ $uid -ge 500 -a ! -d"$dir" -a $user != "nfsnobody" ]

	then

		echo -e "${RED}The home directory $dir of user $user does not exist.${NC}"

		

	else

		echo -e "${GREEN}The home directory $dir of user $user exist.${NC}"

	fi



	#checking user home directory ownership

	if [ $uid -ge 500 -a -d"$dir" -a $user != "nfsnobody" ]

	then

		owner=$(stat -L -c "%U" "$dir")

		if [ "$owner" != "$user" ]

		then

			echo -e "${RED}The home directory ($dir) of user $user is owned by $owner.${NC}"

		else



			echo -e "${GREEN}Then home directory ($dir) of user $user is owned by $owner.${NC}"

		fi

	fi

		

	

done



####################################### 7.18 ######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.18 Check for Duplicate UIDs ${normal}"

echo ' ' 



/bin/cat /etc/passwd | /bin/cut -f3 -d":" | /bin/sort -n | /usr/bin/uniq -c | while read x; do

	[ -z "${x}" ] && break

	set - $x

	if [ $1 -gt 1 ]

	then

		users=`/bin/gawk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | /user/bin/xargs`

		echo -e "${RED}Duplicate UID $2: ${users}${NC}"

	else

		echo -e "${GREEN}There is no duplicate UID $2 ${NC}" 

	fi



done



####################################### 7.19 ######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}7.19 Check for Duplicate GIDs ${normal}"

echo ' '



/bin/cat /etc/group | /bin/cut -f3 -d"." | /bin/sort -n | /usr/bin/uniq -c | while read x; do

	[ -z "${x}" ] && break

	set - $x

	if [ $1 -gt 1 ]

	then

		grp=`/bin/gawk -F: '($3 == n) { print $1 }' n=$2 /etc/group | xargs`

		echo -e "${RED}Duplicate GID $2: $grp$.{NC}"

	else

		echo -e "${GREEN}There is no duplicated GID $2 ${NC}"

	fi

done



#7.20 - Check that reserved UIDs are assigned to only system accounts



echo "${bold}7.20 Check that reserved UIDs are assigned to only system accounts.${normal}"



systemaccount=(root bin daemon adm lp sync shutdown halt mail news uucp operator games gopher ftp nobody nscd vcsa rpc mailnull smmsp pcap ntp dbus avahi sshd rpcuser nfsnobody haldaemon avahi-autoipd distcache apache oprofile webalizer dovecot squid named xfs gdm sabayon usbmuxd rtkit abrt saslauth pulse postfix tcpdump systemd-network tss radvd [51]=qemu)



nameCounter=0

systemNameFile="/etc/passwd"

while IFS=: read -r f1 f2 f3 f4 f5 f6 f7

do

	if [[ $f3 -lt 500 ]]

	then

		for i in ${systemaccount[*]}

		do

			if [[ $f1 == $i ]]

			then

				nameCounter=$((nameCounter+1))

			else

				nameCounter=$((nameCounter+0))

			fi

		done



		if [[ $nameCounter < 1 ]]

		then

			echo "${RED}User '$f1' is not a system account but has a reserved UID of $f3.${NC}"

			

		else

			echo "${GREEN}User '$f1' is a system account and has a reserved UID of $f3.${NC}"

		fi

		nameCounter=0

	fi

done <"$systemNameFile"







#7.21 - Duplicate User Names



echo ""



echo "${bold}7.21 Check for duplicate user names.${normal}"



cat /etc/passwd | cut -f1 -d":" | /bin/sort -n | /usr/bin/uniq -c |

while read x ; do

[ -z "${x}" ] && break

set - $x

if [ $1 -gt 1 ]; then

uids=`/bin/gawk -F: '($1 == n) { print $3 }' n=$2 /etc/passwd | xargs`

echo "${RED}There are $1 duplicate user name titled '$2' found in the system and its respective UIDs are ${uids}.${NC}"

else

	echo "${GREEN}There is no duplicated user name titled '$2' found in the system.${NC}"

fi

done





#7.22 - Duplicate Group Names



echo ""



echo "${bold}7.22 Check for duplicate group names.${normal}"



cat /etc/group | cut -f1 -d":" | /bin/sort -n | /usr/bin/uniq -c | 

while read x ; do

[ -z "${x}" ] && break

set - $x

if [ $1 -gt 1 ]; then

gids=`/bin/gawk -F: '($1 == n) { print $3 }' n=$2 /etc/group | xargs`

echo "${RED}There are $1 duplicate group name titled '$2' found in the system and its respective UIDs are ${gids}.${NC}"

else	

	echo "${GREEN}There is no duplicated group name titled '$2' found in the system.${NC}"

fi

done





#7.23 - Check for presence of user .forward files



echo ""



echo "${bold}7.23 Check for presence of user ./forward files.${normal}"



for dir in `/bin/cat /etc/passwd | /bin/awk -F: '{ print $6 }'`; do

if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then 

echo "${RED}.forward file titled '$dir/.forward' found in the system.${NC}"

else

	echo "${GREEN}.forward file is not found in the system.${NC}"

fi

done



####################################### 8.1 to 8.2 ######################################



#########################################################################

echo "${bold}8.1 Set Warning Banner for Standard Login Services${normal}"



current=$(cat /etc/motd)



standard="WARNING: UNAUTHORIZED USERS WILL BE PROSECUTED!"



if [ "$current" == "$standard" ]; then

        echo "${GREEN}Audit status: PASSED!${NC}"

else

        echo "${RED}Audit status: FAILED!${NC}"

fi

#########################################################################

echo "${bold}8.2 Remove OS Information from Login Warning Banners${normal}"



current1=$(egrep '(\\v|\\r|\\m|\\s)' /etc/issue)

current2=$(egrep '(\\v|\\r|\\m|\\s)' /etc/motd)

current3=$(egrep '(\\v|\\r|\\m|\\s)' /etc/issue.net)



string1="\\v"

string2="\\r"

string3="\\m"

string4="\\s"



if [[ $current1 =~ $string1 || $current1 =~ $string2 || $current1 = ~$string3 || $current1 =~ $string4 ]]; then

        echo "${RED}Audit status: FAILED! [OS Information found in /etc/issue]${NC}"

else

        echo "${GREEN}/etc/issue has no issues. Continuing with verification${NC}"

fi



if [[ $current2 =~ $string1 || $current2 =~ $string2 || $current2 = ~$string3 || $current2 =~ $string4 ]]; then

        echo "${RED}Audit status: FAILED! [OS Information found in /etc/motd]${NC}"

else

        echo "${GREEN}/etc/motd has no issues. Continuing with verification${NC}"

fi



if [[ $current3 =~ $string1 || $current3 =~ $string2 || $current3 = ~$string3 || $current4 =~ $string4 ]]; then

        echo "${RED}Audit status: FAILED! [OS Information found in /etc/issue.net]${NC}"

else

        echo "${GREEN}/etc/issue.net has no issues. Continuing with verification${NC}"

fi

####################################### 9.1 to 9.8 ######################################



#Check whether Anacron Daemon is enabled or not

echo "${bold}9.1 Checking Enable anacron Daemon${normal}"

if rpm -q cronie-anacron

then

	echo "${GREEN} Anacron Daemon has been installed.${NC}"

else

	echo "${RED} Please ensure that you have Anacron Daemon has been installed.${NC}"

fi



#Check if Crond Daemon is enabled

echo "${bold}9.2 Checking Enable crond Daemon${normal}"

checkCronDaemon=$(systemctl is-enabled crond)

if [[ $checkCronDaemon = "enabled" ]]

then

	echo "${GREEN} Crond Daemon has been enabled.${NC}"

else

	echo "${RED} Please ensure that you have enabled crond Daemon.${NC}"

fi



#Check if the correct permissions is configured for /etc/anacrontab

echo "${bold}9.3 Checking User/Group Owner and Permission on /etc/anacrontab

${normal}"

anacrontabFile="/etc/anacrontab"

if [ -e "$anacrontabFile" ]

then

	echo "The Anacrontab file ($anacrontabFile) exists."

	

	anacrontabPerm=$(stat -c "%a" "$anacrontabFile")

	anacrontabRegex="^[0-7]00$"

	if [[ $anacrontabPerm =~ $anacrontabRegex ]]

	then

		echo "${GREEN}Permissions has been set correctly for $anacrontabFile.${NC}"

	else

		echo "${RED}Ensure that the permissions has been set correctly for $anacrontabFile. ${NC}"

	fi



	anacrontabOwn=$(stat -c "%U" "$anacrontabFile")

	if [ $anacrontabOwn = "root" ]

	then

		echo "${GREEN}Owner of the file ($anacrontabFile): $anacrontabOwn ${NC}"

	else

		echo "${RED}Owner of the file ($anacrontabFile): $anacrontabOwn ${NC}"

	fi



	anacrontabGrp=$(stat -c "%G" "$anacrontabFile")

	if [ $anacrontabGrp = "root" ]

	then

		echo "${GREEN}Group owner of the file ($anacrontabFile): $anacrontabGrp ${NC}"

	else

		echo "${RED}Group owner of the file ($anacrontabFile): $anacrontabGrp. Please ensure that the group owner is root instead. ${NC}"

	fi

else

	echo "${RED}The Anacrontab file does not exist. Please ensure that you have Anacron Daemon installed.${NC}"

fi



#Check if the correct permissions has been configured for /etc/crontab

echo "${bold}9.4 Checking User/Group Owner and Permission on /etc/crontab

${normal}"

crontabFile="/etc/crontab"

if [ -e "$crontabFile" ]

then

	crontabPerm=$(stat -c "%a" "$crontabFile")

	crontabRegex="^[0-7]00$"

	if [[ $crontabPerm =~ $crontabRegex ]]

	then

		echo "${GREEN}Permissions has been set correctly for $crontabFile.${NC}"

	else

		echo "${RED}Ensure that the permissions has been set correctly for $crontabFile.${NC}"

	fi



	crontabOwn=$(stat -c "%U" "$crontabFile")

	if [ $crontabOwn = "root" ]

	then

		echo "${GREEN}Owner of the file ($crontabFile): $crontabOwn${NC}"

	else

		echo "${RED}Owner of the file ($crontabFile): $crontabOwn. Please ensure that the owner of the file is root instead.${NC}"

	fi



	crontabGrp=$(stat -c "%G" "$crontabFile")

	if [ $crontabGrp = "root" ]

	then

		echo "${GREEN}Group owner of the file ($crontabFile): $crontabGrp${NC}"

	else

		echo "${RED}Group owner of the file ($crontabFIle): $crontabGrp. Please ensure that the group owner of the file is root instead.${NC}"

	fi



else

	echo "The crontab file ($crontabFile) does not exist."

fi



#Check if the correct permissions has been set for /etc/cron.XXXX

echo "${bold}9.5 Checking the correct permissions has been set for /etc/cron.XXXX

${normal}"

checkCronHDWMPerm(){

	local cronHDWMType=$1

	local cronHDWMFile="/etc/cron.$cronHDWMType"



	if [ -e "$cronHDWMFile" ]

	then

		local cronHDWMPerm=$(stat -c "%a" "$cronHDWMFile")

		local cronHDWMRegex="^[0-7]00$"

		if [[ $cronHDWMPerm =~ $cronHDWMRegex ]]

		then

			echo "${GREEN}Permissions has been set correctly for $cronHDWMFile.${NC}"

		else

			echo "${RED}Ensure that the permissions has been set correctly for $cronHDWMFile.${NC}"

		fi



		local cronHDWMOwn="$(stat -c "%U" "$cronHDWMFile")"

		if [ $cronHDWMOwn = "root" ]

		then

			echo "${GREEN}Owner of the file ($cronHDWMFile): $cronHDWMOwn${NC}"

		else

			echo "${RED}Owner of the file ($cronHDWMFile): $cronHDWMOwn. Please ensure that the owner of the file is root instead.${NC}"

		fi



		local cronHDWMGrp="$(stat -c "%G" "$cronHDWMFile")"

		if [ $cronHDWMGrp = "root" ]

		then

			echo "${GREEN}Group Owner of the file ($cronHDWMFile): $cronHDWMGrp${NC}"

		else

			echo "${RED}Group Owner of the file ($cronHDWMFile): $cronHDWMGrp. Please ensure that the group owner of the file is root instead.${NC}"

		fi

	else

		echo "File ($cronHDWMFile) does not exist."

	fi	

}



checkCronHDWMPerm "hourly"

checkCronHDWMPerm "daily"

checkCronHDWMPerm "weekly"

checkCronHDWMPerm "monthly"



#Check if the permissions has been set correctly for /etc/cron.d

echo "${bold}9.6 Checking if the permissions has been set correctly for /etc/cron.d${normal}"

cronDFile="/etc/cron.d"

if [ -e "$cronDFile" ]

then

	echo "The cron.d file ($cronDFile) exists."

	cronDPerm=$(stat -c "%a" "$cronDFile")

	cronDRegex="^[0-7]00$"

	if [[ $cronDPerm =~ $cronDRegex ]]

	then

		echo "${GREEN}Permissions has been set correctly for $cronDFile.${NC}"

	else

		echo "${RED}Ensure that the permissions has been set correctly for $cronDFile.${NC}"

	fi



	cronDOwn=$(stat -c "%U" "$cronDFile")

	if [ $cronDOwn = "root" ]

	then

		echo "${GREEN}Owner of the file ($cronDFile): $cronDOwn${NC}"

	else

		echo "${RED}Owner of the file ($cronDFile): $cronDOwn. Please ensure that the owner of the file is root instead.${NC}"

	fi



	cronDGrp=$(stat -c "%G" "$cronDFile")

	if [ $cronDGrp = "root" ]

	then

		echo "${GREEN}Group owner of the file ($cronDFile): $cronDGrp${NC}"

	else

		echo "${RED}Group owner of the file ($cronDFile): $cronDGrp. Please ensure that the group owner of the file is root instead.${NC}"

	fi

else

	echo "The cron.d file ($cronDFile) does not exist."

fi



#Check if /etc/at.deny is deleted and that a /etc/at.allow exists and check the permissions of the /etc/at.allow file

echo "${bold}9.7 Checking if /etc/at.deny is deleted and that a /etc/at.allow exists and check the permissions of the /etc/at.allow file${normal}"

atDenyFile="/etc/at.deny"

if [ -e "$atDenyFile" ]

then

	echo "${RED}Please ensure that the file $atDenyFile is deleted.${NC}"

else

	echo "${GREEN}$atDenyFile is deleted as recommended.${NC}"

fi



atAllowFile="/etc/at.allow"

if [ -e "$atAllowFile" ]

then

        atAllowPerm=$(stat -c "%a" "$atAllowFile")

        atAllowRegex="^[0-7]00$"

        if [[ $atAllowPerm =~ $atAllowRegex ]]

        then

            	echo "${GREEN}Permissions has been set correctly for $atAllowFile.${NC}"

        else

            	echo "${RED}Ensure that the permissions has been set correctly for $atAllowFile.${NC}"

        fi



	atAllowOwn=$(stat -c "%U" "$atAllowFile")

        if [ $atAllowOwn = "root" ]

        then

            	echo "${GREEN}Owner of the file ($atAllowFile): $atAllowOwn${NC}"

        else

            	echo "${RED}Owner of the file ($atAllowFile): $atAllowOwn. Please ensure that the owner of the file is root instead.${NC}"

        fi



	atAllowGrp=$(stat -c "%G" "$atAllowFile")

	if [ $atAllowGrp = "root" ]

	then

		echo "${GREEN}Group owner of the file ($atAllowFile): $atAllowGrp${NC}"

	else

		echo "${RED}Group owner of the file ($atAllowFile): $atAllowGrp. Please ensure that the group owner of the file is root instead.${NC}"

	fi

else

	echo "${RED}Please ensure that a $atAllowFile is created for security purposes.${RED}"

fi



#Check if /etc/cron.deny is deleted and that a /etc/cron.allow exists and check the permissions of the /etc/cron.allow file

echo "${bold}9.8 Checking if /etc/cron.deny is deleted and that a /etc/cron.allow exists and check the permissions of the /etc/cron.allow file${normal}"

cronDenyFile="/etc/cron.deny"

if [ -e "$cronDenyFile" ]

then

        echo "${RED}Please ensure that the file $cronDenyFile is deleted.${NC}"

else

	echo "${GREEN}$cronDenyFile is deleted as recommended.${NC}"

fi



cronAllowFile="/etc/cron.allow"

if [ -e "$cronAllowFile" ]

then

    	cronAllowPerm=$(stat -c "%a" "$cronAllowFile")

       	cronAllowRegex="^[0-7]00$"

        if [[ $cronAllowPerm =~ $cronAllowRegex ]]

        then

               	echo "${GREEN}Permissions has been set correctly for $cronAllowFile.${NC}"

        else

               	echo "${RED}Ensure that the permissions has been set correctly for $cronAllowFile.${NC}"

       	fi



       	cronAllowOwn=$(stat -c "%U" "$cronAllowFile")

        if [ $cronAllowOwn = "root" ]

        then

                echo "${GREEN}Owner of the file ($cronAllowFile): $cronAllowOwn${NC}"

        else

               	echo "${RED}Owner of the file ($atAllowFile): $cronAllowOwn. Please ensure that the owner of the file is root instead.${NC}"

    	fi



    	cronAllowGrp=$(stat -c "%G" "$cronAllowFile")

       	if [ $cronAllowGrp = "root" ]

        then

            	echo "${GREEN}Group owner of the file ($cronAllowFile): $cronAllowGrp${NC}"

        else

            	echo "${RED}Group owner of the file ($cronAllowFile): $cronAllowGrp. Please ensure that the group owner of the file is root instead.${NC}"

        fi

else

    	echo "${RED}Please ensure that a $cronAllowFile is created for security purposes.${NC}"

fi



####################################### 10.1 to 10.13 ######################################



#10.1 verification 

echo "${bold}10.1 Set SSH Protocol to 2${normal}"

chksshprotocol=`grep "^Protocol 2" /etc/ssh/sshd_config`



if [ "$chksshprotocol" == "Protocol 2" ]

then

	echo "${GREEN}SSH (Protocol) - Pass${NC}"

else

	echo "${RED}SSH (Protocol) - Fail${NC}"

fi



#10.2 verification

echo "${bold}10.2 Set LogLevel to INFO${normal}"

chksshloglevel=`grep "^LogLevel INFO" /etc/ssh/sshd_config`



if [ "$chksshloglevel" == "LogLevel INFO" ]

then

	echo "${GREEN}SSH (LogLevel) - Pass${NC}"

else

	echo "${RED}SSH (LogLevel) - Fail${NC}"

fi



#10.3 verification 

echo "${bold}10.3 Set Permissions on /etc/ssh/sshd_config${normal}"

deterusergroupownership=`/bin/ls -l /etc/ssh/sshd_config | grep "root root" | grep "\-rw-------"`



if [ -n "deterusergroupownership" ] #-n means not null, -z means null

then

	echo "${GREEN}Ownership (User & Group)- Pass${NC}"

else

	echo "${RED}Ownership (User & Group)- Fail${NC}"

fi



#10.4 verification 

echo "${bold}10.4 Disable SSH X11 Forwarding${normal}"

chkx11forwarding=`grep "^X11Forwarding no" /etc/ssh/sshd_config`



if [ "$chkx11forwarding" == "X11Forwarding no" ]

then

	echo "${GREEN}SSH (X11Forwarding no) - Pass${NC}"

else

	echo "${RED}SSH (X11Forwarding no) - Fail${NC}"

fi



#10.5 verification

echo "${bold}10.5 Set SSH MaxAuthTries to 4 or Less${normal}"

maxauthtries=`grep "^MaxAuthTries 4" /etc/ssh/sshd_config`



if [ "$maxauthtries" == "MaxAuthTries 4" ]

then

	echo "${GREEN}SSH (MaxAuthTries 4) - Pass${NC}"

else

	echo "${RED}SSH (MaxAuthTries 4) - Fail${NC}"

fi



#10.6 verification

echo "${bold}10.6 Set SSH IgnoreRhosts to Yes${normal}"

ignorerhosts=`grep "^IgnoreRhosts yes" /etc/ssh/sshd_config`



if [ "$ignorerhosts" == "IgnoreRhosts yes" ]

then

	echo "${GREEN}SSH (IgnoreRhosts yes) - Pass${NC}"

else

	echo "${RED}SSH (IgnoreRhosts yes) - Fail${NC}"

fi



#10.7 verification

echo "${bold}10.7 Set SSH HostbasedAuthentication to No${normal}"

hostbasedauthentication=`grep "^HostbasedAuthentication no" /etc/ssh/sshd_config`



if [ "$hostbasedauthentication" == "HostbasedAuthentication no" ]

then

	echo "${GREEN}SSH (HostbasedAuthentication no) - Pass${NC}"

else

	echo "${RED}SSH (HostbasedAuthentication no) - Fail${NC}"

fi





#10.8 verification

echo "${bold}10.8 Disable SSH Root Login${normal}"

chksshrootlogin=`grep "^PermitRootLogin" /etc/ssh/sshd_config`



if [ "$chksshrootlogin" == "PermitRootLogin no" ]

then

	echo "${GREEN}SSH (Permit Root Login) - Pass${NC}"

else

	echo "${RED}SSH (Permit Root Login) - Fail${NC}"

fi



#10.9 verification

echo "${bold}10.9 Set SSH PermitEmptyPasswords to No${normal}"

chksshemptypswd=`grep "^PermitEmptyPasswords" /etc/ssh/sshd_config`



if [ "$chksshemptypswd" == "PermitEmptyPasswords no" ]

then

	echo "${GREEN}SSH (Permit Empty Passwords) - Pass${NC}"

else

	echo "${RED}SSH (Permit Empty Passwords) - Fail${NC}"

fi



#10.10 verification

echo "${bold}10.10 Use only Approved Cipher in Counter Mode${normal}"

chksshcipher=`grep "Ciphers" /etc/ssh/sshd_config`



if [ "$chksshcipher" == "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" ]

then

	echo "${GREEN}SSH (Cipher) - Pass${NC}"

else

	echo "${RED}SSH (Cipher) - Fail${NC}"

fi



#10.11 verification

echo "${bold}10.11 Set Idle Timeout Interval for User Login${normal}"

chksshcai=`grep "^ClientAliveInterval" /etc/ssh/sshd_config`

chksshcacm=`grep "^ClientAliveCountMax" /etc/ssh/sshd_config`



if [ "$chksshcai" == "ClientAliveInterval 300" ]

then

	echo "${GREEN}SSH (ClientAliveInterval) - Pass${NC}"

else

	echo "${RED}SSH (ClientAliveInterval) - Fail${NC}"

fi



if [ "$chksshcacm" == "ClientAliveCountMax 0" ]

then

	echo "${GREEN}SSH (ClientAliveCountMax) - Pass${NC}"

else

	echo "${RED}SSH (ClientAliveCountMax) - Fail${NC}"

fi



#10.12 verification		*NOTE: Manually created users and groups as question was not very specific*

echo "${bold}10.12 Limit Access via SSH${normal}"

chksshalwusrs=`grep "^AllowUsers" /etc/ssh/sshd_config`

chksshalwgrps=`grep "^AllowGroups" /etc/ssh/sshd_config`

chksshdnyusrs=`grep "^DenyUsers" /etc/ssh/sshd_config`

chksshdnygrps=`grep "^DenyGroups" /etc/ssh/sshd_config`



if [ -z "$chksshalwusrs" -o "$chksshalwusrs" == "AllowUsers[[:space:]]" ]

then

	echo "${RED}SSH (AllowUsers) - Fail${NC}"

else

	echo "${GREEN}SSH (AllowUsers) - Pass${NC}"

fi



if [ -z "$chksshalwgrps" -o "$chksshalwgrps" == "AllowGroups[[:space:]]" ]

then

	echo "${RED}SSH (AllowGroups) - Fail${NC}"

else

	echo "${GREEN}SSH (AllowGroups) - Pass${NC}"

fi



if [ -z "$chksshdnyusrs" -o "$chksshdnyusrs" == "DenyUsers[[:space:]]" ]

then

	echo "${RED}SSH (DenyUsers) - Fail${NC}"

else

	echo "${GREEN}SSH (DenyUsers) - Pass${NC}"

fi



if [ -z "$chksshdnygrps" -o "$chksshdnygrps" == "DenyGroups[[:space:]]" ]

then

	echo "${RED}SSH (DenyGroups) - Fail${NC}"

else	

	echo "${GREEN}SSH (DenyGroups) - Pass${NC}"

fi



#10.13 verification

echo "${bold}10.13 Set SSH Banner${normal}"

chksshbanner=`grep "Banner" /etc/ssh/sshd_config | awk '{ print $2 }'`



if [ "$chksshbanner" == "/etc/issue.net" -o "$chksshbanner" == "/etc/issue" ]

then

	echo "${GREEN}SSH (Banner) - Pass${NC}"

else

	echo "${RED}SSH (Banner) - Fail${NC}"

fi



####################################### 11 ######################################



#11.1

echo "${bold}11.1 Upgrade Password Hashing Algorithm to SHA-512 ${normal}"

checkPassAlgo=$(authconfig --test | grep hashing | grep sha512)

checkPassRegex=".*sha512"

if [[ $checkPassAlgo =~ $checkPassRegex ]]

then

	echo "${GREEN}The password hashing algorithm is set to SHA-512 as recommended.${NC}"

else

	echo "${RED}Please ensure that the password hashing algorithm is set to SHA-512 as recommended.${NC}"

fi 







#11.2

echo "${bold}11.2  Set Password Creation Requirement Parameters Using pam_pwquality ${normal}"

pampwconf=$(grep pam_pwquality.so /etc/pam.d/system-auth)

correctpampwconf="password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type="

if [[ $pampwconf == $correctpampwconf ]]

then

echo "${GREEN}Recommended settings is already configured.${NC}"

else

echo "${RED}Please configure the settings again.${NC}"

fi



minlen=$(grep "minlen" /etc/security/pwquality.conf)

dcredit=$(grep "dcredit" /etc/security/pwquality.conf)

ucredit=$(grep "ucredit" /etc/security/pwquality.conf)

ocredit=$(grep "ocredit" /etc/security/pwquality.conf)

lcredit=$(grep "lcredit" /etc/security/pwquality.conf)

correctminlen="# minlen = 14"

correctdcredit="# dcredit = -1"

correctucredit="# ucredit = -1"

correctocredit="# ocredit = -1"

correctlcredit="# lcredit = -1"



if [[ $minlen == $correctminlen && $dcredit == $correctdcredit && $ucredit == $correctucredit && $ocredit == $correctocredit && $lcredit == $correctlcredit ]]

then

echo "${GREEN}Recommended settings is already configured.${NC}"

else

echo "${RED}Please configure the settings again.${NC}"

fi









#11.3

echo "${bold}11.3 Set Lockout for Failed Password Attempts ${normal}"

faillockpassword=$(grep "pam_faillock" /etc/pam.d/password-auth)

faillocksystem=$(grep "pam_faillock" /etc/pam.d/system-auth)



read -d '' correctpamauth << "BLOCK" 

auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900

auth        [default=die] pam_faillock.so authfail audit deny=5

auth        sufficient    pam_faillock.so authsucc audit deny=5

account     required      pam_faillock.so

BLOCK



if [[ $faillocksystem == "$correctpamauth" && $faillockpassword == "$correctpamauth" ]]

then

echo "${GREEN}Recommended settings is already configured.${NC}"

else

echo "${RED}Please configure the settings again.${NC}"

fi









#11.4

echo "${bold}11.4 Limit Password Reuse ${normal}"

pamlimitpw=$(grep "remember" /etc/pam.d/system-auth)

if [[ $pamlimitpw == *"remember=5"* ]]

then 

echo "${GREEN}Recommended settings is already configured.${NC}"

else

echo "${RED}Please configure the settings again.${NC}"

fi







#11.5

echo "${bold}11.5 Restrict root Login to System Console${normal}"



systemConsole="/etc/securetty"

systemConsoleCounter=0

while read -r line; do

	if [ -n "$line" ]

	then

		[[ "$line" =~ ^#.*$ ]] && continue

		if [ "$line" == "vc/1" ] || [ "$line" == "tty1" ]

		then

			systemConsoleCounter=$((systemConsoleCounter+1))

		else

			systemConsoleCounter=$((systemConsoleCounter+1))

		fi

	fi

done < "$systemConsole"



if [ $systemConsoleCounter != 2 ]

then

	echo "${RED}Please configure the settings again.${NC}"

else

	echo "${GREEN}Recommended settings is already configured.${NC}"

fi









#11.6

echo "${bold}11.6 Restrict Access to su Command ${normal}"



pamsu=$(grep pam_wheel.so /etc/pam.d/su | grep required)

if [[ $pamsu =~ ^#auth.*required ]]

then

echo "${RED}Please configure the settings for pam_wheel.so again.${NC}"

else

echo "${GREEN}Recommended settings for pam_wheel.so is already configured.${NC}"

fi



pamwheel=$(grep wheel /etc/group)

if [[ $pamwheel =~ ^wheel.*root ]]

then

echo "${GREEN}Recommended settings for wheel group is already configured.${NC}"

else

echo "${RED}Please configure the settings for wheel group again.${NC}"

fi



####################################### END ######################################



echo "------------------------------------------------------------------------------------------"

echo ' '

echo "${bold}End of verification.${normal}"

echo ' '
