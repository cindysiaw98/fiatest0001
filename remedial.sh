#!/bin/bash



#1.1

trap '' 2

trap '' SIGTSTP





checkforsdb1lvm=`fdisk -l | grep /dev/sdb1 | grep "Linux LVM"`

if [ -z "$checkforsdb1lvm" ]

then

	echo "Please create a /dev/sdb1 partition with at least 8GB and LVM system ID first"

else

	printf "/tmp\n"

	tmpcheck=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab`

	if [ -z "$tmpcheck" ]

	then

		vgcheck=`vgdisplay | grep "VG Name" | grep "MyVG"`

		if [ -z "$vgcheck" ]

		then

			vgcreate MyVG /dev/sdb1 &> /dev/null

		fi

		

		lvcheck=`lvdisplay | grep "LV Name" | grep "TMPLV"`

		if [ -z "$lvcheck" ]

		then 

			lvcreate -L 500M -n TMPLV MyVG &> /dev/null

			mkfs.ext4 /dev/MyVG/TMPLV &> /dev/null

		fi

		echo "/dev/MyVG/TMPLV	/tmp	ext4	defaults 0 0" >> /etc/fstab

		mount -a

		echo "Remediation for 1. /tmp partition - FIXED"

	fi

	

#1.2,1.3,1.4 - for persistent

	nodevcheck1=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nodev`

	nosuidcheck1=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nosuid`

	noexeccheck1=`grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep noexec`





	if [ -z "$nodevcheck1" ]

	then

		sed -ie 's:\(.*\)\(\s/tmp\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3nodev,\4\5:' /etc/fstab

		echo "Remediation for 2. nodev for /tmp - FIXED (Persistent)"

	fi





	if [ -z "$nosuidcheck1" ]

	then

		sed -ie 's:\(.*\)\(\s/tmp\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3nosuid,\4\5:' /etc/fstab

		echo "Remediation for 3. nosuid for /tmp - FIXED (Persistent)"

	fi





	if [ -z "$noexeccheck1" ]

	then

		sed -ie 's:\(.*\)\(\s/tmp\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3noexec,\4\5:' /etc/fstab

		echo "Remediation for 4. noexec for /tmp - FIXED (Persistent)"

	fi	



#1.2,1.3,1.4 - for non persistent

	nodevcheck2=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep nodev`

	if [ -z "$nodevcheck2" ]

	then

		mount -o remount,nodev /tmp

		echo "Remediation for 5. nodev for /tmp - FIXED (Non-persistent)"

	fi



	nosuidcheck2=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep nosuid`

	if [ -z "$nosuidcheck2" ]

	then

		mount -o remount,nosuid /tmp

		echo "Remediation for 6. nosuid for /tmp - FIXED (Non-persistent)"

	fi



	noexeccheck2=`mount | grep "[[:space:]]/tmp[[:space:]]" | grep noexec`

	if [ -z "$noexeccheck2" ]

	then

		mount -o remount,noexec /tmp

		echo "Remediation for 7. noexec for /tmp - FIXED (Non-persistent)"

	fi



#1.5

	printf "\n"

	printf "/var\n"

	

	varcheck=`grep "[[:space:]]/var[[:space:]]" /etc/fstab`

	if [ -z "$varcheck" ]

	then

		vgcheck=`vgdisplay | grep "VG Name" | grep "MyVG"`

		if [ -z "$vgcheck" ]

		then

			vgcreate MyVG /dev/sdb1 &> /dev/null

		fi

		

		lvcheck=`lvdisplay | grep "LV Name" | grep "VARLV"`

		if [ -z "$lvcheck" ]

		then 

			lvcreate -L 5G -n VARLV MyVG &> /dev/null

			mkfs.ext4 /dev/MyVG/VARLV &> /dev/null

		fi

		echo "# /dev/MyVG/VARLV	/var	ext4	defaults 0 0" >> /etc/fstab

		mount -a

		echo "Remediation for 1. /var partition - FIXED"

	fi



#1.6 - for persistent

	vartmpdircheck=`ls -l /var | grep "tmp"`

	if [ -z "$vartmpdircheck" ]

	then

		mkdir -p /var/tmp

	fi



	vartmpcheck1=`grep -e "/tmp[[:space:]]" /etc/fstab | grep "/var/tmp"`



	if [ -z "$vartmpcheck1" ]

	then

		echo "# /tmp	/var/tmp	none	bind	0 0" >> /etc/fstab 

		echo "Remediation for 2. /var/tmp bind mount - FIXED (Persistent)"

	fi



#1.6 - for non persistent

	vartmpcheck2=`mount | grep "/var/tmp"`



	if [ -z "$vartmpcheck2" ]

	then

		mount --bind /tmp /var/tmp

		echo "Remediation for 3. /var/tmp bind mount - FIXED (Non-persistent)"

	fi



#1.7

	varlogdircheck=`ls -l /var | grep "log"`

	if [ -z "$varlogdircheck" ]

	then

		mkdir -p /var/log

	fi



	varlogcheck=`grep "[[:space:]]/var/log[[:space:]]" /etc/fstab`

	if [ -z "$varlogcheck" ]

	then

		vgcheck=`vgdisplay | grep "VG Name" | grep "MyVG"`

		if [ -z "$vgcheck" ]

		then

			vgcreate MyVG /dev/sdb1 &> /dev/null

		fi

		

		lvcheck=`lvdisplay | grep "LV Name" | grep "VARLOGLV"`

		if [ -z "$lvcheck" ]

		then 

			lvcreate -L 200M -n VARLOGLV MyVG &> /dev/null

			mkfs.ext4 /dev/MyVG/VARLOGLV &> /dev/null

		fi

		echo "/dev/MyVG/VARLOGLV	/var/log	ext4	defaults 0 0" >> /etc/fstab

		mount -a

		echo "Remediation for 4. /var/log partition - FIXED"

	fi



#1.8

	auditdircheck=`ls -l /var/log | grep "audit"`

	if [ -z "$auditdircheck" ]

	then

		mkdir -p /var/log/audit	

	fi



	varlogauditcheck=`grep "[[:space:]]/var/log/audit[[:space:]]" /etc/fstab`

	if [ -z "$varlogauditcheck" ]

	then

		vgcheck=`vgdisplay | grep "VG Name" | grep "MyVG"`

		if [ -z "$vgcheck" ]

		then

			vgcreate MyVG /dev/sdb1 &> /dev/null

		fi

		

		lvcheck=`lvdisplay | grep "LV Name" | grep "VARLOGAUDITLV"`

		if [ -z "$lvcheck" ]

		then 

			lvcreate -L 200M -n VARLOGAUDITLV MyVG &> /dev/null

			mkfs.ext4 /dev/MyVG/VARLOGAUDITLV &> /dev/null

		fi

		echo "/dev/MyVG/VARLOGAUDITLV	/var/log/audit	ext4	defaults 0 0" >> /etc/fstab

		mount -a

		echo "Remediation for 5. /var/log/audit partition - FIXED"

	fi



#1.9

	printf "\n"

	printf "/home\n"

	

	homecheck=`grep "[[:space:]]/home[[:space:]]" /etc/fstab`

	if [ -z "$homecheck" ]

	then

		vgcheck=`vgdisplay | grep "VG Name" | grep "MyVG"`

		if [ -z "$vgcheck" ]

		then

			vgcreate MyVG /dev/sdb1 &> /dev/null

		fi

		

		lvcheck=`lvdisplay | grep "LV Name" | grep "HOMELV"`

		if [ -z "$lvcheck" ]

		then 

			lvcreate -L 500M -n HOMELV MyVG &> /dev/null

			mkfs.ext4 /dev/MyVG/HOMELV &> /dev/null

		fi

		echo "/dev/MyVG/HOMELV	/home	ext4	defaults 0 0" >> /etc/fstab

		mount -a

		echo "Remediation for 1. /home partition - FIXED"

	fi



#1.10 - for persistent

	homenodevcheck1=`grep "[[:space:]]/home[[:space:]]" /etc/fstab | grep nodev`



	if [ -z "$homenodevcheck1" ]

	then

		sed -ie 's:\(.*\)\(\s/home\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3nodev,\4\5:' /etc/fstab

		echo "Remediation for 2. nodev for /home - FIXED (Persistent)"

	fi



#1.10 - for non-persistent

	homenodevcheck2=`mount | grep "[[:space:]]/home[[:space:]]" | grep nodev`

	if [ -z "$homenodevcheck2" ]

	then

		mount -o remount,nodev /home

		echo "Remediation for 3. nodev for /home - FIXED (Non-persistent)"

	fi

fi



#1.11,1.12,1.13

cdcheck=`grep cd /etc/fstab`

if [ -n "$cdcheck" ]

then

	cdnodevcheck=`grep cdrom /etc/fstab | grep nodev`

	if [ -z "$cdnodevcheck" ]

	then

		sed -ie 's:\(.*\)\(\s/cdrom\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3nodev,\4\5:' /etc/fstab

		echo "Remediation for nodev for /cdrom fixed"

	fi



	cdnosuidcheck=`grep cdrom /etc/fstab | grep suid`

	if [ -z "$cdnosuidcheck" ]

	then

		sed -ie 's:\(.*\)\(\s/cdrom\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3nosuid,\4\5:' /etc/fstab

		echo "Remediation for nosuid for /cdrom fixed"

	fi





	cdnoexeccheck=`grep cdrom /etc/fstab | grep exec`

	if [ -z "$cdnoexeccheck" ]

	then

		sed -ie 's:\(.*\)\(\s/cdrom\s\s*\)\(\w*\s*\)\(\w*\s*\)\(.*\):\1\2\3noexec,\4\5:' /etc/fstab

		echo "Remediation for noexec for /cdrom fixed"

	fi



fi



#1.14

checksticky=`df --local -P | awk {'if (NR!=1) print $6'} | xargs -l '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2> /dev/null`



if [ -n "$checksticky" ]

then

	df --local -P | awk {'if (NR!=1) print $6'} | xargs -l '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2> /dev/null | xargs chmod o+t

fi



echo "Remediation for Sticky bit completed."



#1.15

checkcramfs=`/sbin/lsmod | grep cramfs`

checkfreevxfs=`/sbin/lsmod | grep freevxfs`

checkjffs2=`/sbin/lsmod | grep jffs2`

checkhfs=`/sbin/lsmod | grep hfs`

checkhfsplus=`/sbin/lsmod | grep hfsplus`

checksquashfs=`/sbin/lsmod | grep squashfs`

checkudf=`/sbin/lsmod | grep udf`



if [ -n "$checkcramfs" -o -n "$checkfreevxfs" -o -n "$checkjffs2" -o -n "$checkhfs" -o -n "$checkhfsplus" -o -n "$checksquashfs" -o -n "$checkudf" ]

then

	echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf

	echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf

fi



echo "Remediation for Disabling mounting of legacy filesystem completed."



#2.1

checktelnetserver=`yum list telnet-server | grep "Available Packages"`

if [ -n "$checktelnetserver" ]

then

	echo "Telnet-server is not installed, hence no action will be taken"

else

	echo "Telnet-server is installed, it will now be removed"

	yum erase -y telnet-server > /dev/null 2>&1

fi 



checktelnet=`yum list telnet | grep "Available Packages"`

if [ -n "$checktelnet" ]

then

	echo "Telnet is not installed, hence no action will be taken"

else

	echo "Telnet is installed, it will now be removed"

	yum erase -y telnet > /dev/null 2>&1

fi 



#2.2

checkrshserver=`yum list rsh-server | grep "Available Packages"`

if [ -n "$checkrshserver" ]

then

	echo "Rsh-server is not installed, hence no action will be taken"

else

	echo "Rsh-server is installed, it will now be removed"

	yum erase -y rsh-server > /dev/null 2>&1

fi 



checkrsh=`yum list rsh | grep "Available Packages"`

if [ -n "$checkrsh" ]

then

	echo "Rsh is not installed, hence no action will be taken"

else

	echo "Rsh is installed, it will now be removed"

	yum erase -y rsh > /dev/null 2>&1

fi 



#2.3

checkypserv=`yum list ypserv | grep "Available Packages"`

if [ -n "$checkypserv" ]

then

	echo "Ypserv is not installed, hence no action will be taken"

else

	echo "Ypserv is installed, it will now be removed"

	yum erase -y ypserv > /dev/null 2>&1

fi 



checkypbind=`yum list ypbind | grep "Available Packages"`

if [ -n "$checkypbind" ]

then

	echo "Ypbind is not installed, hence no action will be taken"

else

	echo "Ypbind is installed, it will now be removed"

	yum erase -y ypbind > /dev/null 2>&1

fi 



#2.4

checktftp=`yum list tftp | grep "Available Packages"`

if [ -n "$checktftp" ]

then

	echo "Tftp is not installed, hence no action will be taken"

else

	echo "Tftp is installed, it will now be removed"

	yum erase -y tftp > /dev/null 2>&1

fi



checktftp=`yum list tftp-server| grep "Available Packages"`

if [ -n "$checktftp-server" ]

then

	echo "Tftp-server is not installed, hence no action will be taken"

else

	echo "Tftp-server is installed, it will now be removed"

	yum erase -y tftp-server > /dev/null 2>&1

fi 



#2.5

checkxinetd=`yum list xinetd | grep "Available Packages"`

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence no action will be taken"

else

	echo "Xinetd is installed, it will now be removed"

	yum erase -y xinetd > /dev/null 2>&1

fi 



#2.6

checkxinetd=`yum list xinetd | grep "Available Packages"`

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence chargen-dgram is not installed"

else	

	checkchargendgram=`chkconfig --list chargen-dgram | grep "off"`

	if [ -n "$checkchargendgram" ]

	then

		echo "chargen-dgram is not active, hence no action will be taken"

	else

		echo "chargen-dgram is active, it will now be disabled"

		chkconfig chargen-dgram off > /dev/null 2>&1

	fi 

fi 



#2.7

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence chargen-stream is not installed"

else	

	checkchargenstream=`chkconfig --list chargen-stream | grep "off"`

	if [ -n "$checkchargenstream" ]

	then

		echo "chargen-stream is not active, hence no action will be taken"

	else

		echo "chargen-stream is active, it will now be disabled"

		chkconfig chargen-stream off > /dev/null 2>&1

	fi 

fi 



#2.8

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence daytime-dgram is not installed"

else	

	checkdaytimedgram=`chkconfig --list daytime-dgram | grep "off"`

	if [ -n "$checkdaytimedgram" ]

	then

	echo "daytime-dgram is not active, hence no action will be taken"

	else

	echo "daytime-dgram is active, it will now be disabled"

	chkconfig daytime-dgram off > /dev/null 2>&1

	fi 

fi



if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence daytime-stream is not installed"

else	

	checkdaytimestream=`chkconfig --list daytime-stream | grep "off"`

	if [ -n "$checkdaytimestream" ]

	then

		echo "daytime-stream is not active, hence no action will be taken"

	else

		echo "daytime-stream is active, it will now be disabled"

		chkconfig daytime-stream off > /dev/null 2>&1

	fi 

fi 



#2.9

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence echo-dgram is not installed"

else	

	checkechodgram=`chkconfig --list echo-dgram | grep "off"`

	if [ -n "$checkechodgram" ]

	then

		echo "echo-dgram is not active, hence no action will be taken"

	else

		echo "echo-dgram is active, it will now be disabled"

		chkconfig echo-dgram off > /dev/null 2/&1

	fi

fi



if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence echo-stream is not installed"

else	

	checkechostream=`chkconfig --list echo-stream | grep "off"`

	if [ -n "$checkechostream" ]

	then

		echo "echo-stream is not active, hence no action will be taken"

	else

		echo "echo-stream is active, it will now be disabled"

		chkconfig echo-stream off > /dev/null 2/&1

	fi 

fi



#2.10

if [ -n "$checkxinetd" ]

then

	echo "Xinetd is not installed, hence tcpmux-server is not installed"

else	

	checktcpmuxserver=`chkconfig --list tcpmux-server | grep "off"`

	if [ -n "$checktcpmuxserver" ]

	then

		echo "tcpmux-server is not active, hence no action will be taken"

	else

		echo "tcpmux-server is active, it will now be disabled"

		chkconfig tcpmux-server off > /dev/null 2/&1

	fi 

fi 



echo "Remediation for Xinetd is completed."



#3.1

umaskcheck=`grep ^umask /etc/sysconfig/init`

if [ -z "$umaskcheck" ]

then

	echo "umask 027" >> /etc/sysconfig/init

fi



echo "Remediation for UMASK completed."



#3.2

checkxsystem=`ls -l /etc/systemd/system/default.target | grep graphical.target`

checkxsysteminstalled=`rpm  -q xorg-x11-server-common | grep "not installed"`



if [ -n "$checkxsystem" ]

then

	if [ -z "$checkxsysteminstalled" ]

	then

		rm '/etc/systemd/system/default.target'

		ln -s '/usr/lib/systemd/system/multi-user.target' '/etc/systemd/system/default.target'

		yum remove -y xorg-x11-server-common > /dev/null 2>&1

	fi

fi



echo "Remediation for X Windows System completed."



#3.3

checkavahi=`systemctl status avahi-daemon | grep inactive`

checkavahi1=`systemctl status avahi-daemon | grep disabled`



if [ -z "$checkavahi" -o -z "$checkavahi1" ]

then

	systemctl disable avahi-daemon.service avahi-daemon.socket > /dev/null 2>&1

	systemctl stop avahi-daemon.service avahi-daemon.socket > /dev/null 2>&1

	yum remove -y avahi-autoipd avahi-libs avahi > /dev/null 2>&1

fi



echo "Remediation for AVAHI completed."



#3.4

checkcupsinstalled=`yum list cups | grep "Available Packages" `

checkcups=`systemctl status cups | grep inactive`

checkcups1=`systemctl status cups | grep disabled`

if [ -z "$checkcupsinstalled" ]

then

	if [ -z "$checkcups" -o -z "$checkcups1" ]

	then

		systemctl stop cups > /dev/null 2>&1

		systemctl disable cups > /dev/null 2>&1

	fi

fi



echo "Remediation for CUPS completed."



#3.5

checkyumdhcp=`yum list dhcp | grep "Available Packages" `

checkyumdhcpactive=`systemctl status dhcp | grep inactive `

checkyumdhcpenable=`systemctl status dhcp | grep disabled `

if [ -z "$checkyumdhcp" ]

then

	if [ -z "$checkyumdhcpactive" -o -z "$checkyumdhcpenable" ]

	then

		systemctl disable dhcp > /dev/null 2>&1

		systemctl stop dhcp > /dev/null 2>&1

		yum -y erase dhcp > /dev/null 2>&1

	fi

fi



echo "Remediation for DHCP completed." 



#3.6

checkntpinstalled=`yum list ntp | grep "Installed"`



if [ -z "$checkntpinstalled" ]

then

	yum install -y ntp > /dev/null 2>&1

fi

checkntp1=`grep "^restrict default" /etc/ntp.conf`

checkntp2=`grep "^restrict -6 default" /etc/ntp.conf`

checkntp3=`grep "^server" /etc/ntp.conf`

checkntp4=`grep "ntp:ntp" /etc/sysconfig/ntpd`



if [ "$checkntp1" != "restrict default kod nomodify notrap nopeer noquery" ]

then

	sed -ie '8d' /etc/ntp.conf

	sed -ie '8irestrict default kod nomodify notrap nopeer noquery' /etc/ntp.conf

fi



if [ "$checkntp2" != "restrict -6 default kod nomodify notrap nopeer noquery" ]

then

	sed -ie '9irestrict -6 default kod nomodify notrap nopeer noquery' /etc/ntp.conf

fi



if [ -z "$checkntp3" ]

then

	sed -ie '21iserver 10.10.10.10' /etc/ntp.conf #Assume 10.10.10.10 is NTP server

fi



if [ -z "$checkntp4" ]

then

	sed -ie '2d' /etc/sysconfig/ntpd

	echo "1iOPTIONS=\"-u ntp:ntp -p /var/run/ntpd.pid\" " >> /etc/sysconfig/ntpd

fi



echo "Remediation for NTP completed."



#3.7

checkldapclientinstalled=`yum list openldap-clients | grep "Available Packages"`

checkldapserverinstalled=`yum list openldap-servers | grep "Available Packages"`



if [ -z "$checkldapclientinstalled" ]

then

	yum  -y erase openldap-clients > /dev/null 2>&1

fi



if [ -z "$checkldapserverinstalled" ]

then

	yum -y erase openldap-servers > /dev/null 2>&1

fi



echo "Remediation for LDAP completed."



#3.8

checknfslock=`systemctl is-enabled nfs-lock | grep "disabled"`

checknfssecure=`systemctl is-enabled nfs-secure | grep "disabled"`

checkrpcbind=`systemctl is-enabled rpcbind | grep "disabled"`

checknfsidmap=`systemctl is-enabled nfs-idmap | grep "disabled"`

checknfssecureserver=`systemctl is-enabled nfs-secure-server | grep "disabled"`



if [ -z "$checknfslock" ]

then

	systemctl disable nfs-lock > /dev/null 2>&1

fi



if [ -z "$checknfssecure" ]

then

	systemctl disable nfs-secure > /dev/null 2>&1

fi



if [ -z "$checkrpcbind" ]

then

	systemctl disable rpcbind > /dev/null 2>&1

fi



if [ -z "$checknfsidmap" ]

then

	systemctl disable nfs-idmap > /dev/null 2>&1

fi



if [ -z "$checknfssecureserver" ]

then

	systemctl disable nfs-secure-server /dev/null 2>&1

fi



echo "Remediation for NFS and RPC completed."



#3.9

checkyumdns=`yum list bind | grep "Available Packages" `

checkdns=`systemctl status named | grep inactive`

checkdns1=`systemctl status named | grep disabled`

if [ -z "$checkyumdns" ]

then

	if [ -z "$checkdns" -o -z "$checkdns1" ]

	then

		systemctl stop named > /dev/null 2>&1

		systemctl disable named /dev/null 2>&1

	fi

fi



echo "Remediation for DNS completed."



checkyumftp=`yum list vsftpd | grep "Available Packages" `

checkftp=`systemctl status vsftpd | grep inactive`

checkftp1=`systemctl status vsftpd | grep disabled`

if [ -z "$checkyumftp" ]

then

	if [ -z "$checkftp" -o -z "$checkftp1" ]

	then

		systemctl stop vsftpd > /dev/null 2>&1

		systemctl disable vsftpd > /dev/null 2>&1

	fi

fi



echo "Remediation for FTP completed."



checkyumhttp=`yum list httpd | grep "Available Packages" `

checkhttp=`systemctl status httpd | grep inactive`

checkhttp1=`systemctl status httpd | grep disabled`

if [ -z "$checkyumhttp" ]

then

	if [ -z "$checkhttp" -o -z "$checkhttp1" ]

	then

		systemctl stop httpd > /dev/null 2>&1

		systemctl disable httpd > /dev/null 2>&1

	fi

fi



echo "Remediation for HTTP completed."



checkyumsquid=`yum list squid | grep "Available Packages" `

checksquid=`systemctl status squid | grep inactive`

checksquid=`systemctl status squid | grep disabled`

if [ -z "$checkyumsquid" ]

then

	if [ -z "$checksquid" -o -z "$checksquid1" ]

	then

		systemctl stop squid > /dev/null 2>&1

		systemctl disable squid > /dev/null 2>&1

	fi

fi



echo "Remediation for HTTP_Proxy completed."



checkyumsnmp=`yum list net-snmp | grep "Available Packages" `

checksnmp=`systemctl status snmpd | grep inactive`

checksnmp1=`systemctl status snmpd | grep disabled`

if [ -z "$checkyumsnmp" ]

	then

	if [ -z "$checksnmp" -o -z "$checsnmp1" ]

	then

		systemctl stop snmpd > /dev/null 2>&1

		systemctl disable snmpd > /dev/null 2>&1

	fi

fi



echo "Remediation for SNMP completed."



#3.10

checkmta=`netstat -an | grep LIST | grep "127.0.0.1:25[[:space:]]"`



if [ -z "$checkmta" ]

then

	sed -ie '116iinet_interfaces = localhost' /etc/postfix/main.cf

fi



echo "Remediation for MTA completed."#!/bin/bash



trap '' 2

#To stop "Control-C"



#To stop "Control-Z"

trap '' SIGTSTP



#To create a space

printf "\n"



#4.1

echo -e "\e[4m4.1 : Set User/Group Owner on /boot/grub2/grub.cfg\e[0m"

checkowner=$(stat -L -c "owner=%U group=%G" /boot/grub2/grub.cfg)

if [ "$checkowner" == "owner=root group=root" ]

then

	#If owner and group is configured CORRECTLY

	printf "\nBoth owner and group belong to ROOT user : PASSED"

	printf "\n$checkowner"

else

	#If owner and group is configured INCORRECTLY

	chown root:root /boot/grub2/grub.cfg

	printf "\nBoth owner and group belong to ROOT user : FAILED"

	printf "\nChanging the owner and group..."

	printf "\nDone, Change SUCCESSFUL\n"

fi

	echo "Remediation for setting of user and group owner for /boot/grub2/grub.cfg completed."





#To create space

printf "\n\n"



#4.2

echo -e "\e[4m4.2 : Set Permissions on /boot/grub2/grub.cfg\e[0m"

checkpermission=$(stat -L -c "%a" /boot/grub2/grub.cfg | cut -c 2,3)

if [ "$checkpermission" == 00 ]

then

	#If the permission is configured CORRECTLY

	printf "\nConfiguration of Permission: PASSED"

else

	#If the permission is configured INCORRECTLY

	printf "\nConfiguration of Permission: FAIlED"

	printf "\nChanging configuration..."

	chmod og-rwx /boot/grub2/grub.cfg

	printf "\nDone, Change SUCCESSFUL\n"

fi



echo "Remediation for setting of permissions for /boot/grub2/grub.cfg completed."



# To create space

printf "\n\n"



#4.3

echo -e "\e[4m4.3 : Set Boot Loader Password\e[0m"

checkboot=$(grep "set superusers" /boot/grub2/grub.cfg | sort | head -1 | awk -F '=' '{print $2}' | tr -d '"')

user=$(grep "set superusers" /boot/grub2/grub.cfg | sort | head -1 | awk -F '=' '{print $2}')

if [ "$checkboot" == "root" ]

then

	#If the configuration is CORRECT

	printf "\nBoot Loader Settings : PASSED"

	printf "\nThe following are the superusers: "

	printf "$user\n\n"

else

	#If the configuration is INCORRECT

	printf "\nBoot Loader Settings : FAILED"

	printf "\nConfiguring Boot Loader Settings..."

	printf "\n"

	printf "password\npassword" >> /etc/bootloader.txt

	grub2-mkpasswd-pbkdf2 < /etc/bootloader.txt > /etc/boot.md5

	printf "\n" >> /etc/grub.d/00_header

	printf "cat << EOF\n" >> /etc/grub.d/00_header

	printf "set superusers=root\n" >> /etc/grub.d/00_header

	ans=$(cat /etc/boot.md5 | grep "grub" | awk -F ' ' '{print $7}')

	printf "passwd_pbkdf2 root $ans\n" >> /etc/grub.d/00_header

	printf "EOF" >> /etc/grub.d/00_header

	grub2-mkconfig -o /boot/grub2/grub.cfg &> /dev/null

	printf "\nBoot loader settings are now configured"

	printf "\n"

	newuser=$(grep "set superusers" /boot/grub2/grub.cfg | sort | head -1 | awk -F '=' '{print $2}')



	printf "\nThe following are the superusers: "

	printf "$newuser\n\n"

fi

echo "Remediation for setting of boot loader password for /boot/grub2/grub.cfg completed."



# To have space

printf "\n"



#5.1

echo -e "\e[4m5.1 : Restrict Core Dumps\e[0m"

checkcoredump=$(grep "hard core" /etc/security/limits.conf)

if [ -z "$checkcoredump" ]

then

	#If it is configured INCORRECTLY

	printf "\nHard Limit Settings : FAILED"

	printf "\n* hard core 0" >> /etc/security/limits.conf

	printf "\nfd.suid_dumpable = 0" >> /etc/sysctl.conf

	printf "\nConfiguring settings...."

	printf "\nDone, Change SUCCESSFUL"

else

	#If it is configured CORRECTLY

	printf "\nHard Limit Settings : PASSED\n"

fi

echo "Remediation for restrict core dumps completed."



# To have space

printf "\n\n"



#5.2

echo -e "\e[4m5.2 : Enable Randomized Virtual Memory Region Placement\e[0m"

checkkernel=$(sysctl kernel.randomize_va_space)

checkkerneldeep=$(sysctl kernel.randomize_va_space | awk -F ' ' '{print $3}')

if [ "$checkkerneldeep" == 2 ]

then

	#If the configurations are CORRECT

	printf "\nVirtual Memory Randomization Settings : PASSED"

	printf "\nRandomization of Virtual Memory : "

	printf "$checkkernel\n"

else

	#If the configuratiions are INCORRECT

	printf "\nVirtual Memory Randomization Settings : FAILED"

	echo 2 > /proc/sys/kernel/randomize_va_space

	printf "\nConfiguring settings...."

	printf "\nDone, Change SUCCESSFUL"

	printf "\n\nNew Randomization of Virtual Memory : "

	newcheckkernel=$(sysctl kernel.randomize_va_space)

	printf "$newcheckkernel\n"

fi

echo "Remediation for Randomized Virtual Memory Region Placement completed."



# To have space

printf "\n\n"



# To have space



printf "============================================================================\n"

printf "6.1 : Configure rsyslog\n"

printf "============================================================================\n"

printf "\n"



#6.1.1

echo -e "\e[4m6.1.1 : Install the rsyslogpackage\e[0m"

checkrsyslog=`rpm -q rsyslog | grep "^rsyslog"`

if [ -n "$checkrsyslog" ]

then

	printf "\nRsyslog : PASSED (Rsyslog is already installed)"

else

	echo "\nRsyslog : FAILED (Rsyslog is not installed)"

	echo "\nRsyslog service will now be installed"

	yum -y install rsyslog &> /dev/null

	echo "\nRsyslog successfully downloaded"

fi



echo "Remediation for installation of rsyslog package completed."



printf "\n\n\n"



#6.1.2

echo -e "\e[4m6.1.2 : Activate the rsyslog Service\e[0m"

checkrsysenable=`systemctl is-enabled rsyslog`

if [ "$checkrsysenable" == "enabled" ]

then

	printf "\nRsyslog Enabled - PASSED (Rsyslog is already enabled)"

else

	printf "\nRsyslog Enabled - FAILED (Rsyslog is disabled)"

	systemctl enable rsyslog > /dev/null 2>&1

	echo "\nRsyslog is now enabled."

fi



echo "Remediation for activation of rsyslog completed."



printf "\n\n\n"



#6.1.3

echo -e "\e[4m6.1.3 : Configure /etc/rsyslog.conf\e[0m\n"

checkmessages=$(cat /etc/rsyslog.conf | grep "/var/log/messages" | awk -F ' ' '{print $1}')

if [ "$checkmessages" != "auth,user.*" ]

then

	#Change it here (If it is not a null)

	if [ -n "$checkmessages" ]

	then

		sed -i /$checkmessages/d /etc/rsyslog.conf

	fi

		printf "\nauth,user.*	/var/log/messages" >> /etc/rsyslog.conf

		echo "Facility will be now changed to auth,user.* for /var/log/messages.log"

else

	#Correct

	echo "/var/log/messages : PASSED (Facility is configured correctly)"

fi 



checkkern=$(cat /etc/rsyslog.conf | grep "/var/log/kern.log" | awk -F ' ' '{print $1}')

if [ "$checkkern" != "kern.*" ]

then

		printf "\n"

		echo "/var/log/kern.log : FAILED (Facility is configured incorrectly)"

        #Change it here

		if [ -n "$checkkern" ]

		then

        	sed -i /$checkkern/d /etc/rsyslog.conf

		fi

        printf "\nkern.*   /var/log/kern.log" >> /etc/rsyslog.conf

        echo "Facility will be now changed to kern.* for /var/log/kern.log"

else

        #Correct

        echo "/var/log/kern.log : PASSED (Facility is configured correctly)"

fi 





checkdaemon=$(cat /etc/rsyslog.conf | grep "/var/log/daemon.log" | awk -F ' ' '{print $1}')

if [ "$checkdaemon" != "daemon.*" ]

then

		printf "\n"

		echo "/var/log/daemon.log : FAILED (Facility is configured incorrectly)"

        #Change it here

		if [ -n "$checkdaemon" ]

		then

				sed -i /$checkdaemon/d /etc/rsyslog.conf

		fi

		printf "\ndaemon.*   /var/log/daemon.log" >> /etc/rsyslog.conf

        echo "Facility will be now changed to daemon.* for /var/log/daemon.log"

else

        #Correct

        echo "/var/log/daemon.log : PASSED (Facility is configured correctly)"

fi 





checksyslog=$(cat /etc/rsyslog.conf | grep "/var/log/syslog" | awk -F ' ' '{print $1}')

if [ "$checksyslog" != "syslog.*" ]

then

		printf "\n"

		echo "/var/log/syslog.log : FAILED (Facility is configured incorrectly)"

        #Change it here

		if [ -n "$checksyslog" ]

		then

        	sed -i /$checksyslog/d /etc/rsyslog.conf

		fi

        printf "\nsyslog.*   /var/log/syslog.log" >> /etc/rsyslog.conf

        echo "Facility will be now changed to syslog.* for /var/log/syslog.log"

else

        #Correct

        echo "/var/log/syslog : PASSED (Facility is configured correctly)"

fi 





checkunused=$(cat /etc/rsyslog.conf | grep "/var/log/unused.log" | awk -F ' ' '{print $1}')

if [ "$checkunused" != "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" ]

then

		printf "\n"

		echo "/var/log/unused.log : FAILED (Facility is configured incorrectly)"

        #Change it here

		if [ -n "$checkunused" ]

		then

        	sed -i /$checkunused/d /etc/rsyslog.conf

        fi

		printf "\nlpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*   /var/log/unused.log" >> /etc/rsyslog.conf

        echo "Facility will be now changed to lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.* for /var/log/unused.log"

else

        #Correct

        echo "/var/log/unused.log : PASSED (Facility is configured correctly)"

fi



pkill -HUP rsyslogd

echo "Remediation for configuration of /etc/rsyslog.conf completed."



# To have space

printf "\n\n"



#6.1.4

echo -e "\e[4m6.1.4 : Create and Set Permissions on rsyslog Log Files\e[0m"



checkformsgfile=$(ls /var/log/ | grep messages)

if [ -z "$checkformsgfile" ]

then

	printf "\n/var/log/messages : FAILED (/var/log/messages file does not exist)"

	printf "\nFile will now be created"

	touch /var/log/messages

else

	printf "\n/var/log/messages : PASSED (/var/log/messages file exist)"

fi



checkmsgowngrp=$(ls -l /var/log/messages | awk -F ' ' '{print $3,$4}')

if [ "$checkmsgowngrp" != "root root" ]

then

	#It is configured wrongly

	printf "\n/var/log/messages : FAILED (Owner and Group owner of file is configured wrongly)"

	chown root:root /var/log/messages

	printf "\nOwner and Group owner will now be changed to root root"	

else

	printf "\n/var/log/messages : PASSED (Owner and Group owner of file is configured correctly)"

fi



checkmsgper=$(ls -l /var/log/messages | awk -F ' ' '{print $1}')

if [ "$checkmsgper" != "-rw-------." ]

then

	printf "\n/var/log/messages : FAILED (Permission of file is configured wrongly)"

	chmod og-rwx /var/log/messages

	printf "\nPermission of file will now be changed to 0600"

else

	printf "\n/var/log/messages : PASSED (Permission of file is configured correctly)"

fi



printf "\n"



# kern.log

checkforkernfile=$(ls /var/log/ | grep kern.log)

if [ -z "$checkforkernfile" ]

then

	printf "\n/var/log/kern.log : FAILED (/var/log/kern.log file does not exist)"

	printf "\nFile will now be created"

	touch /var/log/kern.log

else

	printf "\n/var/log/kern.log : PASSED (/var/log/kern.log file exist)"

fi



checkkernowngrp=$(ls -l /var/log/kern.log | awk -F ' ' '{print $3,$4}')

if [ "$checkkernowngrp" != "root root" ]

then

	#It is configured wrongly

	printf "\n/var/log/kern.log : FAILED (Owner and Group owner of file is configured wrongly)"

	chown root:root /var/log/kern.log

	printf "\nOwner and Group owner will now be changed to root root"	

else

	printf "\n/var/log/kern.log : PASSED (Owner and Group owner of file is configured correctly)"

fi



checkkernper=$(ls -l /var/log/kern.log | awk -F ' ' '{print $1}')

if [ "$checkkernper" != "-rw-------." ]

then

	printf "\n/var/log/kern.log : FAILED (Permission of file is configured wrongly)"

	chmod og-rwx /var/log/kern.log

	printf "\nPermission of file will now be changed to 0600"

else

	printf "\n/var/log/kern.log : PASSED (Permission of file is configured correctly)"

fi



printf "\n"



#daemon.log

checkfordaefile=$(ls /var/log/ | grep daemon.log)

if [ -z "$checkfordaefile" ]

then

	printf "\n/var/log/daemon.log : FAILED (/var/log/daemon.log file does not exist)"

	printf "\nFile will now be created"

	touch /var/log/daemon.log

else

	printf "\n/var/log/daemon.log : PASSED (/var/log/daemon.log file exist)"

fi



checkdaeowngrp=$(ls -l /var/log/daemon.log | awk -F ' ' '{print $3,$4}')

if [ "$checkdaeowngrp" != "root root" ]

then

	#It is configured wrongly

	printf "\n/var/log/daemon.log : FAILED (Owner and Group owner of file is configured wrongly)"

	chown root:root /var/log/daemon.log

	printf "\nOwner and Group owner will now be changed to root root"	

else

	printf "\n/var/log/daemon.log : PASSED (Owner and Group owner of file is configured correctly)"

fi



checkdaeper=$(ls -l /var/log/daemon.log | awk -F ' ' '{print $1}')

if [ "$checkdaeper" != "-rw-------." ]

then

	printf "\n/var/log/daemon.log : FAILED (Permission of file is configured wrongly)"

	chmod og-rwx /var/log/daemon.log

	printf "\nPermission of file will now be changed to 0600"

else

	printf "\n/var/log/daemon.log : PASSED (Permission of file is configured correctly)"

fi



printf "\n"



#syslog.log

checkforsysfile=$(ls /var/log/ | grep syslog.log)

if [ -z "$checkforsysfile" ]

then

	printf "\n/var/log/syslog.log : FAILED (/var/log/syslog.log file does not exist)"

	printf "\nFile will now be created"

	touch /var/log/syslog.log

else

	printf "\n/var/log/syslog.log : PASSED (/var/log/syslog.log file exist)"

fi



checksysowngrp=$(ls -l /var/log/syslog.log | awk -F ' ' '{print $3,$4}')

if [ "$checksysowngrp" != "root root" ]

then

	#It is configured wrongly

	printf "\n/var/log/syslog.log : FAILED (Owner and Group owner of file is configured wrongly)"

	chown root:root /var/log/syslog.log

	printf "\nOwner and Group owner will now be changed to root root"	

else

	printf "\n/var/log/syslog.log : PASSED (Owner and Group owner of file is configured correctly)"

fi



checksysper=$(ls -l /var/log/syslog.log | awk -F ' ' '{print $1}')

if [ "$checksysper" != "-rw-------." ]

then

	printf "\n/var/log/syslog.log : FAILED (Permission of file is configured wrongly)"

	chmod og-rwx /var/log/syslog.log

	printf "\nPermission of file will now be changed to 0600"

else

	printf "\n/var/log/syslog.log : PASSED (Permission of file is configured correctly)"

fi



printf "\n"



#unused

checkforunufile=$(ls /var/log/ | grep unused.log)

if [ -z "$checkforunufile" ]

then

	printf "\n/var/log/unused.log : FAILED (/var/log/unused.log file does not exist)"

	printf "\nFile will now be created"

	touch /var/log/unused.log

else

	printf "\n/var/log/unused.log : PASSED (/var/log/unused.log file exist)"

fi



checkunuowngrp=$(ls -l /var/log/unused.log | awk -F ' ' '{print $3,$4}')

if [ "$checkunuowngrp" != "root root" ]

then

	#It is configured wrongly

	printf "\n/var/log/unused.log : FAILED (Owner and Group owner of file is configured wrongly)"

	chown root:root /var/log/unused.log

	printf "\nOwner and Group owner will now be changed to root root"	

else

	printf "\n/var/log/unused.log : PASSED (Owner and Group owner of file is configured correctly)"

fi



checkunuper=$(ls -l /var/log/unused.log | awk -F ' ' '{print $1}')

if [ "$checkunuper" != "-rw-------." ]

then

	printf "\n/var/log/unused.log : FAILED (Permission of file is configured wrongly)"

	chmod og-rwx /var/log/unused.log

	printf "\nPermission of file will now be changed to 0600"

else

	printf "\n/var/log/unused.log : PASSED (Permission of file is configured correctly)"

fi



printf "\n"



echo "Remediation for setting permisions of all rsyslog log files completed."



# To have space

printf "\n\n"



#6.1.5

echo -e "\e[4m6.1.5 : Configure rsyslogto Send Logs to a Remote Log Host\e[0m\n"

checkloghost=$(grep "^*.*[^|][^|]*@" /etc/rsyslog.conf)

if [ -z "$checkloghost" ]  # If there is no log host

then

	printf "Remote Log Host : FAILED (Remote log host has not been configured)\n"

	printf "\nRemote log host will now be configured"

	printf "\n*.* @@logfile.example.com\n" >> /etc/rsyslog.conf

	

else

	printf "Remote Log Host : PASSED (Remote log host has been configured)\n"

fi



echo "Remediation for rsyslog to send logs completed." 



#6.1.6

printf "\n\n"



echo -e "\e[4m6.1.6 : Accept Remote rsyslog Messages Only on Designated Log Hosts\e[0m"

checkmodload=$(grep '^$ModLoad imtcp.so' /etc/rsyslog.conf)

checkinput=$(grep '^$InputTCPServerRun' /etc/rsyslog.conf)

if [ -z "$checkmodload" ]

then

	# If the thing has been commented out

	printf "\nModLoad imtcp.so : FAILED (ModLoad imtcp is not configured)"

	printf "\n\$ModLoad imtcp.so" >> /etc/rsyslog.conf

	printf "\nModLoad imtcp will now be configured\n"

else

	#If the string has not been commented out

	printf "\nModLoad imtcp : PASSED (ModLoad imtcp is configured)\n"

fi





if [ -z "$checkinput" ]

then

	# If the string has been commented ouit

    printf "\nInputTCPServerRun : FAILED (InputTCPServerRun is not configured)"

	printf "\n\$InputTCPServerRun 514" >> /etc/rsyslog.conf

    printf "\nInputTCPServerRun wil now be configured\n"

else

    #If the string has not been commented out

    printf "\nInputTCPServerRun : PASSED (InputTCPServerRun is configured)\n"

fi



pkill -HUP rsyslogd



echo "Remediation for accept remote rsyslog messages only on designated log hosts completed."



# To have space

printf "\n\n"



printf "============================================================================\n"

printf "6.2 : Configure System Accounting\n"

printf "============================================================================\n"

printf "\n"

echo "----------------------------------------------------------------------------"

printf "6.2.1 : Configure Data Retention\n"

echo "----------------------------------------------------------------------------"

printf "\n"



#6.2.1.1

echo -e "\e[4m6.2.1.1 : Configure Audit Log Storage Size\e[0m\n"

checkvalue=$(grep -w "max_log_file" /etc/audit/auditd.conf | awk -F ' ' '{print $3}')

if [ "$checkvalue" != "5" ]

then

	printf "Audit Log Storage Size : FAILED (Maximum size of audit log file is configured incorrectly)\n"

	sed -i /$checkvalue/d /etc/audit/auditd.conf

	printf "max_log_file = 5" >> /etc/audit/auditd.conf

	printf "Audit log storage size value will now be configured\n"

else

	printf "Audit Log Storage Size : PASSED (Maximum size of audit log file is configured correctly)\n"

fi



printf "\n\n"

echo "Remediation for Audit log storage size completed."





#6.2.1.2

echo -e "\e[4m6.2.1.2 : Keep All Auditing Information\e[0m\n"

checkvalue2=$(grep -w "max_log_file_action" /etc/audit/auditd.conf | awk -F ' ' '{print $3}')

if [ "$checkvalue2" != "keep_logs" ]

then

	printf "Audit Information : FAILED (All audit logs are not retained)\n"

    sed -i /$checkvalue2/d /etc/audit/auditd.conf

    printf "\nmax_log_file_action = keep_logs" >> /etc/audit/auditd.conf

    printf "All audit log files will now be retained\n"

else

    printf "Audit Information: PASSED (Audit logs are retained)\n"

fi



printf "\n\n"

echo "Remediation for keeping auditing information completed."





#6.2.1.3

echo -e "\e[4m6.2.1.3 : Disable System on Audit Log Full\e[0m\n"

checkvalue3=$(grep -w "space_left_action" /etc/audit/auditd.conf | awk -F ' ' '{print $3}')

if [ "$checkvalue3" != "email" ]

then

	printf "Action : FAILED (Action to take on low disk space is configured incorrectly)\n"

    sed -i /$checkvalue3/d /etc/audit/auditd.conf

    printf "\nspace_left_action = email" >> /etc/audit/auditd.conf

    printf "Action to take on low disk space will now be configured\n"

else

    printf "Action : PASSED (Action to take on low disk space is configured correctly)\n"

fi



printf "\n"



checkvalue4=$(grep -w "action_mail_acct" /etc/audit/auditd.conf | awk -F ' ' '{print $3}')

if [ "$checkvalue4" != "root" ]

then

	printf "Email Account : FAILED (Email account specified for warnings to be sent to is configured incorrectly)\n"

    sed -i /$checkvalue4/d /etc/audit/auditd.conf

    printf "\naction_mail_acct = root" >> /etc/audit/auditd.conf

    printf "Email account specified for warnings to be sent to will now be configured\n"

else

    printf "Email Account : PASSED (Email account specified for warnings to be sent to is configured correctly)\n"

fi



printf "\n"



checkvalue5=$(grep -w "admin_space_left_action" /etc/audit/auditd.conf | awk -F ' ' '{print $3}')

if [ "$checkvalue5" != "halt" ]

then

	printf "Admin Action : FAILED (Admin action to take on low disk space is configured incorrectly)\n"

    sed -i /$checkvalue5/d /etc/audit/auditd.conf

    printf "\nadmin_space_left_action = halt" >> /etc/audit/auditd.conf

    printf "Admin action to take on low disk space will now be configured\n"

else

    printf "Admin Action : PASSED (Admin action to take on low disk space is configured correctly)\n"

fi



printf "\n\n"

echo "Remediation for disable system on audit log full completed."



#6.2.1.4

echo -e "\e[4m6.2.1.4 : Enable auditd Service\e[0m\n"

checkauditdservice=`systemctl is-enabled auditd`

if [ "$checkauditdservice" == enabled ]

then

	echo "Auditd Service : PASSED (Auditd is enabled)"



else

	echo "Auditd Service : FAILED (Auditd is not enabled)"

	systemctl enable auditd

	echo "Auditd Service is now enabled"

fi

echo "Remediation for enabling of auditd service completed."



printf "\n\n"



#6.2.1.5

echo -e "\e[4m6.2.1.5 : Enable Auditing for Processes That Start Prior to auditd\e[0m\n"

checkgrub=$(grep "linux" /boot/grub2/grub.cfg | grep "audit=1") 

if [ -z "$checkgrub" ]

then

	printf "System Log Processes : FAILED (System is not configured to log processes that start prior to auditd\n"

	var="GRUB_CMDLINE_LINUX"

	sed -i /$var/d /etc/default/grub

	printf "GRUB_CMDLINE_LINUX=\"audit=1\"" >> /etc/default/grub

	printf "System will now be configured to log processes that start prior to auditd\n"

	grub2-mkconfig -o /boot/grub2/grub.cfg &> /dev/null

else

	printf "System Log Processes : PASSED (System is configured to log processes that start prior to auditd\n"

fi



echo "Remediation for enabling auditing processes completed." 



printf "\n\n"



#6.2.1.6

echo -e "\e[4m6.2.1.6 : Record Events That Modify Date and Time Information\e[0m\n"

checksystem=`uname -m | grep "64"`

checkmodifydatetimeadjtimex=`egrep 'adjtimex|settimeofday|clock_settime' /etc/audit/audit.rules`

if [ -z "$checksystem" ]

then

	echo "It is a 32-bit system."

	printf "\n"

	if [ -z "$checkmodifydatetimeadjtimex" ]

	then

        echo "Date & Time Modified Events : FAILED (Events where system date and/or time has been modified are not captured)"

        echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/audit.rules

		echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules

		echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules

        echo "Events where system date and/or time has been modified will now be captured"



	else

		echo "Date & Time Modified Events : PASSED (Events where system date and/or time has been modified are captured)"

	fi



else

	echo "It is a 64-bit system."

	printf "\n"

	if [ -z "$checkmodifydatetimeadjtimex" ]

	then

        echo "Date & Time Modified Events : FAILED (Events where system date and/or time has been modified are not captured)"

		echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/audit.rules

        echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/audit.rules

		echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/audit.rules

        echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules

		echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules

        echo "Events where system date and/or time has been modified will now be captured"



	else

		echo "Date & Time Modified Events : PASSED (Events where system date and/or time has been modified are captured)"

	fi



fi



pkill -P 1 -HUP auditd

echo "Remediation for recording of events - modify of date and time information completed."



printf "\n\n"





#6.1.2.7

echo -e "\e[4m6.2.1.7 : Record Events That Modify User/Group Information\e[0m\n"

checkmodifyusergroupinfo=`egrep '\/etc\/group' /etc/audit/audit.rules`



if [ -z "$checkmodifyusergroupinfo" ]

then

        echo "Group Configuration - FAILED (Group is not configured)"

        echo "-w /etc/group -p wa -k identity" >> /etc/audit/audit.rules

		echo "-w /etc/group -p wa -k identity" >> /etc/audit/rules.d/audit.rules

        echo "Group will now be configured"



else

        echo "Group Configuration - PASSED (Group is already configured)"

fi



printf "\n"



checkmodifyuserpasswdinfo=`egrep '\/etc\/passwd' /etc/audit/audit.rules`



if [ -z "$checkmodifyuserpasswdinfo" ]

then

        echo "Password Configuration - FAILED (Password is not configured)"

        echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/audit.rules

		echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/rules.d/audit.rules

        echo "Password will now be configured"



else

        echo "Password Configuration - PASSED (Password is configured)"

fi



printf "\n"



checkmodifyusergshadowinfo=`egrep '\/etc\/gshadow' /etc/audit/audit.rules`



if [ -z "$checkmodifyusergshadowinfo" ]

then

        echo "GShadow Configuration - FAILED (GShadow is not configured)"

        echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/audit.rules

		echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/rules.d/audit.rules

        echo "GShadow will now be configured"



else

        echo "GShadow Configuration - PASSED (GShadow is configured)"

fi



printf "\n"



checkmodifyusershadowinfo=`egrep '\/etc\/shadow' /etc/audit/audit.rules`



if [ -z "$checkmodifyusershadowinfo" ]

then

        echo "Shadow Configuration - FAILED (Shadow is not configured)"

        echo "-w /etc/shadow -p -k identity" >> /etc/audit/audit.rules

		echo "-w /etc/shadow -p -k identity" >> /etc/audit/rules.d/audit.rules

        echo "Shadow will now be configured"

else

        echo "SHadow Configuration - PASSED (Shadow is configured)"

fi



printf "\n"



checkmodifyuseropasswdinfo=`egrep '\/etc\/security\/opasswd' /etc/audit/audit.rules`



if [ -z "$checkmodifyuseropasswdinfo" ]

then

        echo "OPasswd Configuration- FAILED (OPassword not configured)"

        echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/audit.rules

		echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/rules.d/audit.rules

        echo "OPassword will now be configured"



else

        echo "OPasswd Configuration - PASSED (OPassword is configured)"

fi



pkill -P 1 -HUP auditd

echo "Remediation for recording of events - modify of user/group information completed."



printf "\n\n"



#6.2.1.8

echo -e "\e[4m6.2.1.8 : Record Events That Modify the System's Network Environment\e[0m\n"

checksystem=`uname -m | grep "64"`

checkmodifynetworkenvironmentname=`egrep 'sethostname|setdomainname' /etc/audit/audit.rules`



if [ -z "$checksystem" ]

then

	echo "It is a 32-bit system."

	printf "\n"

	if [ -z "$checkmodifynetworkenvironmentname" ]

	then

        echo "Modify the System's Network Environment Events : FAILED (Sethostname and setdomainname is not configured)"

        echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules

        echo "Sethostname and setdomainname will now be configured"



	else

		echo "Modify the System's Network Environment Events : PASSED (Sethostname and setdomainname is configured)"

	fi



else

	echo "It is a 64-bit system."

	printf "\n"

	if [ -z "$checkmodifynetworkenvironmentname" ]

	then

        echo "Modify the System's Network Environment Events : FAILED (Sethostname and setdomainname is not configured)"

        echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules

		echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules

        echo "Sethostname will now be configured"



	else

		echo "Modify the System's Network Environment Events : PASSED (Sethostname and setdomainname is configured)"

	fi



fi



printf "\n"



checkmodifynetworkenvironmentissue=`egrep '\/etc\/issue' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmentissue" ]

then

       	echo "Modify the System's Network Environment Events : FAILED (/etc/issue is not configured)"

       	echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/audit.rules

       	echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/audit.rules

       	echo "/etc/issue will now be configured"



else

       	echo "Modify the System's Network Environment Events : PASSED (/etc/issue is configured)"

fi



printf "\n"



checkmodifynetworkenvironmenthosts=`egrep '\/etc\/hosts' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmenthosts" ]

then

       	echo "Modify the System's Network Environment Events : FAILED (/etc/hosts is not configured)"

       	echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/audit.rules

       	echo "/etc/hosts will now be configured"



else

       	echo "Modify the System's Network Environment Events : PASSED (/etc/hosts is configured)"

fi



printf "\n"



checkmodifynetworkenvironmentnetwork=`egrep '\/etc\/sysconfig\/network' /etc/audit/audit.rules`



if [ -z "$checkmodifynetworkenvironmentnetwork" ]

then

       	echo "Modify the System's Network Environment Events : FAILED (/etc/sysconfig/network is not configured)"

       	echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules

		echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/audit.rules

       	echo "/etc/sysconfig/network will now be configured"



else

       	echo "Modify the System's Network Environment Events : PASSED (/etc/sysconfig/network is configured)"

fi



pkill -P 1 -HUP auditd

echo "Remediation for recording of events - modify of system network environment completed."



printf "\n\n"



#6.1.2.9

echo -e "\e[4m6.2.1.9 : Record Events That Modify the System's Mandatory Access Controls\e[0m\n"

var=$(grep \/etc\/selinux /etc/audit/audit.rules)

if [ -z "$var" ]

then

	printf "Monitoring SELinux Mandatory Access Controls : FAILED (/etc/selinux is not configured)\n"

	printf "\n-w /etc/selinux/ -p wa -k MAC-policy" >> /etc/audit/audit.rules

	printf "/etc/selinux will now be configured"

else

	printf "Monitoring SELinux Mandatory Access Controls : PASSED (/etc/selinux is configured)\n"

fi



pkill -P 1 -HUP auditd

echo "Remediation for recording of events - modify of access controls completed."



printf "\n\n"
