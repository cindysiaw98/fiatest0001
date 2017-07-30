#!/bin/bash

GREEN="\033[0;32m"

RED="\033[0;31m"

NC="\033[0m"

bold=$(tput bold)

normal=$(tput sgr0)

echo "testing123"

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

### Carisse Verification ###

### Wanling Verification ###
