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

# ! /bin/bash



#6.2.1.10

loginfail=`grep "\-w /var/log/faillog -p wa -k logins" /etc/audit/audit.rules`

loginlast=`grep "\-w /var/log/lastlog -p wa -k logins" /etc/audit/audit.rules`

logintally=`grep "\-w /var/log/tallylog -p wa -k logins" /etc/audit/audit.rules`



if [ -z "$loginfail" -o -z "$loginlast" -o -z "$logintally" ]

then

	if [ -z "$loginfail" ]

	then

		echo "-w /var/log/faillog -p wa -k logins" >> /etc/audit/audit.rules

	fi

	if [ -z "$loginlast" ]

	then

		echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/audit.rules

	fi

	if [ -z "$logintally" ]

	then

		echo "-w /var/log/tallylog -p wa -k logins" >> /etc/audit/audit.rules

	fi

fi

	

pkill -P 1 -HUP auditd



echo "Remediation for collecting of login and logout events completed."



#6.2.1.11

sessionwtmp=`egrep '\-w /var/log/wtmp -p wa -k session' /etc/audit/audit.rules`

sessionbtmp=`egrep '\-w /var/log/btmp -p wa -k session' /etc/audit/audit.rules`

sessionutmp=`egrep '\-w /var/run/utmp -p wa -k session' /etc/audit/audit.rules`



if [ -z "$sessionwtmp" -o -z "$sessionbtmp" -o -z "$sessionutmp" ]

then 

	if [ -z "$sessionwtmp"]

	then 

		echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/audit.rules

	fi

	if [ -z "$sessionbtmp"]

	then 

		echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/audit.rules

	fi

	if [ -z "$sessionutmp"]

	then

		echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules

	fi

fi



pkill -HUP -P 1 auditd



echo "Remediation for collecting of session information completed."



#6.2.1.12

permission1=`grep "\-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



permission2=`grep "\-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



permission3=`grep "\-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S|chown -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



permission4=`grep "\-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S|chown -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



permission5=`grep "\-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -Fauid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



permission6=`grep "\-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" /etc/audit/audit.rules`



if [ -z "$permission1" -o -z "$permission2" -o -z permission3 -o -z permission4 -o -z permission5 -o -z permission6  ]

then 

	if [ -z "$permission1" ]

	then

		echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules

	fi



	if [ -z "$permission2" ]

	then 

		echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules

	fi

	if [ -z "$permission3" ]

	then 

		echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules

	fi

	if [ -z "$permission4" ]

	then

		echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules

	fi

	if [ -z "$permission5" ]

	then 

		echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules

	fi

	if [ -z "$permission6" ]

	then 

		echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules



	fi

fi

pkill -P 1 -HUP auditd



echo "Remediation for collecting of access control permission modification events completed."



#6.2.1.13

access1=`grep "\-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



access2=`grep "\-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



access3=`grep "\-a always,exit -F arch=b64 -S creat -S open -S ope

nat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



access4=`grep "\-a always,exit -F arch=b32 -S creat -S open -S ope

nat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



access5=`grep "\-a always,exit -F arch=b32 -S creat -S open -S ope

nat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



access6=`grep "\-a always,exit -F arch=b32 -S creat -S open -S ope

nat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" /etc/audit/audit.rules`



if [ -z "$access1" -o -z "$access2" ]

then

	if [ -z "$access1" ]

	then     

   		echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" >> /etc/audit/audit.rules

	fi

	if [ -z "$access2" ]

	then 

		echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" >> /etc/audit/audit.rules

	fi

	if [ -z "$access3" ]

	then

		echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" >>  /etc/audit/audit.rules

	fi

	if [ -z "$access4" ]

	then 

		echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" >>  /etc/audit/audit.rules

	fi

	if [ -z "$access5" ]

	then

		echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 - k access" >>  /etc/audit/audit.rules

	fi

	if [ -z "$access6" ]

	then 

		echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 - k access" >>  /etc/audit/audit.rules

	fi

fi



pkill -P 1 -HUP auditd



echo "Remediation for collecting of unsuccessful unauthorized access attempts completed."



#6.2.1.14

find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print "-a always,exit-F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" }' > /tmp/1.log

checkpriviledge=`cat /tmp/1.log`

cat /etc/audit/audit.rules | grep -- "$checkpriviledge" > /tmp/2.log

checkpriviledgenotinfile=`grep -F -x -v -f /tmp/2.log /tmp/1.log`



if [ -n "$checkpriviledgenotinfile" ]

then

	echo "$checkpriviledgenotinfile" >> /etc/audit/audit.rules

fi



rm /tmp/1.log

rm /tmp/2.log



echo "Remediation for collecting of use of privileged commands completed."



#6.2.1.15

bit64mountb64=`grep "\-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`

bit64mountb32=`grep "\-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`

bit32mountb32=`grep "\-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" /etc/audit/audit.rules`



if [ -z "$bit64mountb64" ]

then

	echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules

fi



if [ -z "$bit64mountb32" ]

then

	echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules

fi





if [ -z "$bit32mountb32" ]

then

	echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules

fi



pkill -HUP -P 1 auditd



echo "Remediation for collecting of successful file systems mounts completed."



#6.2.1.16 

bit64delb64=`grep "\-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`

bit64delb32=`grep "\-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`

bit32delb32=`grep "\-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" /etc/audit/audit.rules`



if [ -z "$bit64delb64" ]

then

	echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules

fi



if [ -z "$bit64delb32" ]

then

	echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules

fi



if [ -z "$bit32delb32" ]

then

	echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules

fi



pkill -P 1 -HUP auditd



echo "Remediation for collecting of file deletion events completed."



#6.2.1.17

sudoers=`grep "\-w /etc/sudoers -p wa -k scope" /etc/audit/audit.rules`



if [ -z "$sudoers" ]

then

	echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/audit.rules

fi

pkill -HUP -P 1 auditd



echo "Remediation for collecting of changes to System Administrator Scope completed."



#6.2.1.18

remauditrules=`grep actions /etc/audit/audit.rules`

auditrules='-w /var/log/sudo.log -p wa -k actions'



if [ -z "$remauditrules" -o "$remauditrules" != "$auditrules" ] 

then

	echo "$auditrules" >> /etc/audit/audit.rules

fi



pkill -HUP -P 1 auditd



echo "Remediation for collecting of System Administrator Actions completed."



#6.2.1.19

remmod1=`grep "\-w /sbin/insmod -p x -k modules" /etc/audit/audit.rules`

remmod2=`grep "\-w /sbin/rmmod -p x -k modules" /etc/audit/audit.rules`

remmod3=`grep "\-w /sbin/modprobe -p x -k modules" /etc/audit/audit.rules`

remmod4=`grep "\-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" /etc/audit/audit.rules`



if [ -z "$remmod1" -o -z "$remmod2" -o -z "$remmod3" -o -z "$remmod4" -o -z "$remmod5" ]

then

	if [ -z "$remmod1" ]

	then

		echo "-w /sbin/insmod -p x -k modules" >> /etc/audit/audit.rules

	fi



	if [ -z "$remmod2" ]

	then	

		echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/audit.rules

	fi



	if [ -z "$remmod3" ]

	then

		echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/audit.rules

	fi



	if [ -z "$remmod4" ]

	then

		echo "-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/audit.rules

	fi

fi



echo "Remediation for collecting of Kernel Module loading and unloading completed."



#6.2.1.20

remimmute=`grep "^-e 2" /etc/audit/audit.rules`

immute='-e 2'



if [ -z "$remimmute" -o "$remimmute" != "$immute" ]

then

	echo "$immute" >> /etc/audit/audit.rules

fi



echo "Remediation for making audit configuration immutable completed."



#6.2.1.21

remlogrotate=`grep "/var/log" /etc/logrotate.d/syslog`

logrotate='/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron {'



if [ -z "$remlogrotate" -o "$remlogrotate" != "$logrotate" ]

then

	rotate1=`grep "/var/log/messages" /etc/logrotate.d/syslog`

	rotate2=`grep "/var/log/secure" /etc/logrotate.d/syslog`

	rotate3=`grep "/var/log/maillog" /etc/logrotate.d/syslog`

	rotate4=`grep "/var/log/spooler" /etc/logrotate.d/syslog`

	rotate5=`grep "/var/log/boot.log" /etc/logrotate.d/syslog`

	rotate6=`grep "/var/log/cron" /etc/logrotate.d/syslog`

	

	if [ -z "$rotate1" ]

	then

		echo "/var/log/messages" >> /etc/logrotate.d/syslog

	fi



	if [ -z "$rotate2" ]

	then

		echo "/var/log/secure" >> /etc/logrotate.d/syslog

	fi



	if [ -z "$rotate3" ]

	then 

		echo "/var/log/maillog" >> /etc/logrotate.d/syslog

	fi



	if [ -z "$rotate4" ]

	then

		echo "/var/log/spooler" >> /etc/logrotate.d/syslog

	fi



	if [ -z "$rotate5" ]

	then

		echo "/var/log/boot.log" >> /etc/logrotate.d/syslog

	fi



	if [ -z "$rotate6" ]

	then

		echo "/var/log/cron" >> /etc/logrotate.d/syslog

	fi

fi



echo "Remediation for configuring of logrotate completed."





#7.1

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.1 Set Password Expiration Days"



current=$(cat /etc/login.defs | grep "^PASS_MAX_DAYS" | awk '{ print $2 }')

standard=90 #change this value according to the enterprise's required standard

if [ ! $current = $standard ]; then

  sed -i "s/^PASS_MAX_DAYS.*99999/PASS_MAX_DAYS $standard/" /etc/login.defs | grep "^PASS_MAX_DAYS.*$standard"

fi



echo "Remediation for setting password expiration days completed."



#7.2

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.2 Set Password Change Minimum Number of Days"



current=$(cat /etc/login.defs | grep "^PASS_MIN_DAYS" | awk '{ print $2 }')

standard=7 #change this value according to the enterprise's required standard

if [ ! $current = $standard ]; then

	sed -i "s/^PASS_MIN_DAYS.*0/PASS_MIN_DAYS $standard/" /etc/login.defs | grep "^PASS_MIN_DAYS.*$standard"

fi



echo "Remediation for setting password minimum days completed."



#7.3

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.3 Set Password Expiring Warning Days"



current=$(cat /etc/login.defs | grep "^PASS_WARN_AGE" | awk '{ print $2 }')

standard=7 #change this value according to the enterprise's required standard

if [ ! $current = $standard ]; then

	sed -i "s/^PASS_WARN_AGE.*0/PASS_WARN_AGE $standard/" /etc/login.defs | grep "^PASS_WARN_AGE.*$standard"

fi



echo "Remediation for setting password expiring warning days completed."



#7.4

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.4 Disable System Accounts"



for user in `awk -F: '($3 < 1000) { print $1 }' /etc/passwd` ; do 

	if [ $user != "root" ]; then 

		usermod -L $user &> /dev/null 

		if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then

			usermod -s /sbin/nologin $user &> /dev/null

			fi 

		fi 

	done

	

echo "Remediation for disabling system accounts completed."



#7.5

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.5 Set Default Group for root Account"

 

current=$(grep "^root:" /etc/passwd | cut -f4 -d:)

  

if [ "$current" == 0 ]; then

    echo "Default Group for rooot Account is already set correctly"

    exit 0

else

    usermod -g 0 root

    echo "Default Group for root Account is modified successfully"

fi



echo "Remediation for setting defauly group for root account completed."



#7.6

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.6 Set Default umask for Users"



remedy=$(egrep -h "\s+umask ([0-7]{3})" /etc/bashrc /etc/profile | awk '{ print $2 }')



if [ "$remedy" != 077 ];then 

	sed -i 's/022/077/g' /etc/profile /etc/bashrc

	sed -i 's/002/077/g' /etc/profile /etc/bashrc

fi



echo "Remediation for setting default umask for users completed."



#7.7

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.7 Lock Inactive User Accounts"



useradd -D -f 35



echo "Remediation for locking inactive user accounts completed."



#7.8

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.8 Ensure Password Fields are Not Empty"



current=$(cat /etc/shadow | awk -F: '($2 == ""){print $1}')



for line in ${current}

do

	/usr/bin/passwd -l ${line}	

done



echo "Remediation for ensuring password fields are not empty completed."



#7.9

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.9 Verify No Legacy "+" Entries Exist in /etc/passwd,/etc/shadow,/etc/group"



passwd=$(grep '^+:' /etc/passwd)

shadow=$(grep '^+:' /etc/shadow)

group=$(grep '^+:' /etc/group)



for accounts in $passwd

do

  	if [ "$accounts" != "" ];then

                userdel --force $accounts

                groupdel --force $accounts

fi

done



echo "Remediation for verifying no legacy entries completed."



#7.10

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 7.10 Verify No UID 0 Accounts Exist Other Than Root"



remedy=$(/bin/cat /etc/passwd | /bin/awk -F: '($3 == 0) { print $1 }')



for accounts in $remedy

do

	if [ "$accounts" != "root" ];then

		userdel --force $accounts

		groupdel --force $accounts

fi

done



echo "Remediation for verifying no UID 0 accounts exist completed."



#!/bin/bash

####################################### 7.12 ######################################

x=0

while [ $x = 0 ]

do

        clear

        echo "Do you want to set all user home directory permission as default? (y/n) - Press 'q' to quit."

        read answer

        case "$answer" in

                y)

                echo "You said - yes"

                intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"

                if [ -z "$intUserAcc" ]

                then

                        echo "There is no interactive user account."

                        echo ' '

                else

                        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

                                chmod g-x $line

                                chmod o-rwx $line

                                echo "Directory $line permission is set default."

                        done

                fi

		 x=1

                ;;

                n)

                echo "You said -No"

                x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

                *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done

echo "Remediation for the checking of permissions for User Home Directories has been completed."



####################################### 7.13 #######################################



x=0

while [ $x = 0 ]

do

        clear

        echo "Do you want to set all user hidden file permission as default? (y/n) - Press 'q' to quit."

        read answer

        case "$answer" in

                y)

                echo "You said - yes"

                intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"

                if [ -z "$intUserAcc" ]

                then

                        echo "There is no interactive user account."

                        echo ' '

                else

                        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

                                hiddenfiles="$(echo .*)"



                                if [ -z "$hiddenfiles" ]

                                then

                                        echo "There is no hidden files."

                                else

					for file in ${hiddenfiles[*]}

                                        do

                                                chmod g-w $file

                                                chmod o-w $file

                                                echo "User directory $line hidden file $file permission is set as default"

                                        done

                                fi

                        done

                fi

                x=1

                ;;

                n)

                echo "You said -No"

                x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

  *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done



echo "Remediation for the checking of permissions for User Dot Files has been completed."



####################################### 7.14 #######################################



x=0

while [ $x = 0 ]

do

        clear

        echo "Do you want to set all user .netrc file  permission as default? (y/n) - Press 'q' to quit."

        read answer

        case "$answer" in

                y)

                echo "You said - yes"

                intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"

                if [ -z "$intUserAcc" ]

                then

                        echo "There is no interactive user account."

                        echo ' '

                else

                        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

				  permission="$(ls -al $line | grep .netrc)"

                                if [ -z "$permission" ]

                                then

                                        echo "There is no .netrc file in user directory $line"

                                        echo ' '

                                else

                                        ls -al $line | grep .netrc | while read -r netrc; do

                                                for file in $netrc

                                                do



 cd $line



 if [[ $file = *".netrc"* ]]



 then



         chmod go-rwx $file



         echo "User directory $line .netrc file $file permission is set as default"



 fi

                                                done

                                        done

                                fi

                        done

                fi

                x=1

                ;;

		 n)

                echo "You said -No"

                x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

                *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done

echo "Remediation for the checking of existence and permissions for User .netrc Files has been completed."



####################################### 7.15 #######################################



intUserAcc="$(/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }')"

if [ -z "$intUserAcc" ]

then

        #echo "There is no interactive user account."

        echo ''

else

        /bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' | /bin/awk -F: '($7 != "/sbin/nologin"){ print $6 }' | while read -r line; do

                #echo "Checking user home directory $line"

		rhostsfile="$(ls -al $line | grep .rhosts)"

                if  [ -z "$rhostsfile" ]

                then

                        #echo " There is no .rhosts file"

                        echo ''

                else

                        ls -al $line | grep .rhosts | while read -r rhosts; do

                                for file in $rhosts

                                do

                                        if [[ $file = *".rhosts"* ]]

                                        then

                                                #echo " Checking .rhosts file $file"

                                                #check if file created user matches directory user

                                                filecreateduser=$(stat -c %U $line/$file)

                                                if [[ $filecreateduser = *"$line"* ]]

                                                then

#echo -e "${GREEN} $file created user is the same user in the directory${NC}"



 echo ''

                                                else



 #echo -e "${RED} $file created user is not the same in the directory. This file should be deleted! ${NC}"



 echo ''

                                                        cd $line



 rm $file

                                                fi

                                        fi

                                done

                        done

                fi

        done

fi

echo "Remediation for the checking of existence for User .rhosts Files has been completed."

echo "Remediation for 7.16 groups in /etc/passwd"

x=0

while [ $x = 0 ]

do

        clear

	echo "Groups defined in /etc/passwd file but not in /etc/group file will pose a threat to system security since the group permission are not properly managed."

        echo ' '

	echo " For all groups that are already defined in /etc/passwd, do you want to defined them in /etc/group? (y/n) - Press 'q' to quit."

        read answer

        case "$answer" in

                y)

                echo "You said - yes"

                

		for i in $(cut -s -d: -f4 /etc/passwd | sort -u); do

        		grep -q -P "^.*?:x:$i:" /etc/group

        		if [ $? -ne 0 ]

        		then

                		#echo -e "${RED}Group $i is referenced by /etc/passwd but does not exist in /etc/group${NC}"

				groupadd -g $i group$i

			fi

		done





                x=1

                ;;

                n)

                echo "You said -No"

                x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

                *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done

echo "Remediation for groups in /etc/passwd has been completed."



####################################### 7.17 ######################################



echo "Remediation for 7.17 users without valid home directories"

x=0

while [ $x = 0 ]

do

        clear

	echo "Users without assigned home directories should be removed or assigned a home directory."

	echo ' '

	echo " For all users without assigned home directories, press 'a' to assign a home directory, 'b' to remove user or 'q' to quit."

        read answer

        case "$answer" in

                a)

                echo "You choose to assign a home directory for all users without an assigned home directory."

                cat /etc/passwd | awk -F: '{ print $1,$3,$6 }' | while read user uid dir; do

                        if [ $uid - ge 500 -a ! -d"$dir" -a $user != "nfsnobody" ]

                        then

				mkhomedir_helper $user

                        fi

                done

                x=1

                ;;

                b)

                echo "You choose to remove all users without an assigned home directory."

		cat /etc/passwd | awk -F: '{ print $1,$3,$6 }' | while read user uid dir; do

			if [ $uid - ge 500 -a ! -d"$dir" -a $user != "nfsnobody" ]

			then

				userdel -r -f $user

			fi

		done

		x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

                *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done

echo "Remediation for users without valid home directories has been completed."



echo "Remediation for 7.17 For users without ownership for its home directory"

x=0

while [ $x = 0 ]

do

        clear

        echo "For new users, the home directory on the server is automatically created with BUILTIN\Administrators set as owner. Hence, these users might not have ownership over its home directory."

        echo ' '

        echo " Do you want to set ownership for users without ownership over its home directory? (y/n) -- Press 'q' to quit."

        read answer

        case "$answer" in

                y)

                echo "You have said - yes."

		cat /etc/passwd | awk -F: '{ print $1,$3,$6 }' | while read user uid dir; do

                        if [ $uid -ge 500 -a -d"$dir" -a $user != "nfsnobody" ]

                        then

				sudo chown $user: $dir

                        fi

                done

                x=1

                ;;

                n)

                echo "You have said - no."

                x=1

                ;;

                q)

                x=1

                echo "Exiting..."

                sleep 2

                ;;

                *)

                clear

                echo "This is not an option"

                sleep 3

                ;;

        esac

done

echo "Remediation for users without ownership for its home directory has been completed."



#7.23 Check for presence of user .forward files

echo ""



echo "7.23 Check for presence of user .forward files."



for dir in `/bin/cat /etc/passwd | /bin/awk -F: '{ print $6 }'`; do

if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then

	chmod u-x $dir/.forward

	chmod g-rwx $dir/.forward

	chmod o-rwx $dir/.forward

	echo "Remediation performed for presence of $dir/.forward file."

	echo "$dir/.forward can only be read and written by the owner only now."

fi

done

echo "Renediation for the checking of the presence for .forward files has been completed." 









#8.1

---------------------------------------------------------------------------------------------------------------



echo "Current Remediation Process: 8.1 Set Warning Banner for Standard Login Services"

touch /etc/motd

echo "Authorized uses only. All activity may be \ monitored and reported." > /etc/issue

echo "Authorized uses only. All activity may be \ monitored and reported." > /etc/issue.net



for file in /etc/motd /etc/issue /etc/issue.net

do

	chown root:root $file; chmod 644 $file

done

#8.2

---------------------------------------------------------------------------------------------------------------

echo "Current Remediation Process: 8.2 Remove OS Information from Login Warning Banners"



current1=$(egrep '(\\v|\\r|\\m|\\s)' /etc/issue)

current2=$(egrep '(\\v|\\r|\\m|\\s)' /etc/motd)

current3=$(egrep  '(\\v|\\r|\\m|\\s)' /etc/issue.net)



string1="\\v"

string2="\\r"

string3="\\m"

string4="\\s"



if [[ $current1 =~ $string1 || $current1 =~ $string2 || $current1 =~ $string3 || $current1 =~ $string4 ]]; then

        sed -i.bak '/\\v\|\\r\|\\m\|\\s/d' /etc/issue

fi



if [[ $current2 =~ $string1 || $current2 =~ $string2 || $current2 =~ $string3 || $current2 =~ $string4 ]]; then

        sed -i.bak '/\\v\|\\r\|\\m\|\\s/d' /etc/motd

fi





if [[ $current3 =~ $string1 || $current3 =~ $string2 || $current3 =~ $string3 || $current4 =~ $string4 ]]; then

        sed -i.bak '/\\v\|\\r\|\\m\|\\s/d' /etc/issue.net

fi



echo "Remediation for removing OS information from logging warning banners completed."






#!/bin/bash

#9.1

#Check whether Anacron Daemon is installed or not and install if it is found to be uninstalled



if rpm -q cronie-anacron

then

    	echo "Remediation passed: Anacron Daemon is installed."

else

    	sudo yum install cronie-anacron -y > /dev/null 2>&1

fi



if rpm -q cronie-anacron #double checking 

then

	:

else

	echo "It seems as if an error has occured and the Anacron Daemon service cannot be installed. Pleas ensure that you have created a yum repository."

fi



echo "Remediation for enabling anacron daemon completed."



#9.2

#Check if Crond Daemon is enabled and enable it if it is not enabled

checkCrondDaemon=$(systemctl is-enabled crond)

if [ "$checkCrondDaemon" = "enabled" ]

then

    	echo "Remediation passed: Crond Daemon is enabled."

else

    	systemctl enable crond > /dev/null 2>&1

	doubleCheckCrondDaemon=$(systemctl is-enabled crond)

	if [ "$doubleCheckCrondDaemon" = "enabled" ]

	then

		:

	else

		echo "It seems as if an error has occurred and crond cannot be enabled. Please ensure that you have a yum repository available and cron service installed (yum install cron -y)."

	fi

fi



echo "Remediation for enabling crond daemon completed."



#9.3

#Check if the correct permissions is configured for /etc/anacrontab and configure them if they are not

anacrontabFile="/etc/anacrontab"

anacrontabPerm=$(stat -c "%a" "$anacrontabFile")

anacrontabRegex="^[0-7]00$"

if [[ $anacrontabPerm =~ $anacrontabRegex ]]

then

	echo "Remedation passed: The correct permissions has been configured for $anacrontabFile."

else

	sudo chmod og-rwx $anacrontabFile

	anacrontabPermCheck=$(stat -c "%a" "$anacrontabFile")

        anacrontabRegexCheck="^[0-7]00$"

	if [[ $anacrontabPermCheck =~ $anacrontabRegexCheck ]]

	then

		:

	else

		echo "It seems as if an error has occured and the permissions for $anacrontabFile cannot be configured as required."

	fi

fi



anacrontabOwn=$(stat -c "%U" "$anacrontabFile")

if [ $anacrontabOwn = "root" ]

then

	echo "Remediation passed: The owner of the file $anacrontabFile is root."

else

	sudo chown root:root $anacrontabFile

	anacrontabOwnCheck=$(stat -c "%U" "$anacrontabFile")

       	if [ $anacrontabOwnCheck = "root" ]

       	then

                :

	else

		echo "It seems as if an error has occured and the owner of the file ($anacrontabFile) cannot be set as root."

        fi

fi



anacrontabGrp=$(stat -c "%G" "$anacrontabFile")

if [ $anacrontabGrp = "root" ]

then

	echo "Remediation passed: The group owner of the file $anacrontabFile is root."

else

	sudo chown root:root $anacrontabFile

	anacrontabGrpCheck=$(stat -c "%G" "$anacrontabFile")

        if [ $anacrontabGrpCheck = "root" ]

	then

		: 

	else

		echo "It seems as if an error has occured and the group owner of the $anacrontabFile file cannot be set as root instead."

        fi

fi



echo "Remediation for setting permissions on /etc/anacrontab completed."



#9.4

#Check if the correct permissions has been configured for /etc/crontab and configure them if they are not

crontabFile="/etc/crontab"

crontabPerm=$(stat -c "%a" "$crontabFile")

crontabRegex="^[0-7]00$"

if [[ $crontabPerm =~ $crontabRegex ]]

then

	echo "Remediation passed: The correct permissions has been set for $crontabFile."

else

	sudo chmod og-rwx $crontabFile

	checkCrontabPerm=$(stat -c "%a" "$crontabFile")

	checkCrontabRegex="^[0-7]00$"

	if [[ $checkCrontabPerm =~ $checkCrontabRegex ]]

	then

		:

	else

		echo "It seems as if an error has occured and the permisions of the file $crontabFile cannot be set as recommended."

	fi

fi



crontabOwn=$(stat -c "%U" "$crontabFile")

if [ $crontabOwn = "root" ]

then

	echo "Remediation passed: The owner of the file $crontabFile is root."

else

	sudo chown root:root $crontabFile

	checkCrontabOwn=$(stat -c "%U" "$crontabFile")

	if [ $checkCrontabOwn = "root" ]

	then

        	:

	else

		echo "It seems as if an error has occured and that the owner of the $crontabFile file cannot be set as root instead."

	fi



fi



crontabGrp=$(stat -c "%G" "$crontabFile")

if [ $crontabGrp = "root" ]

then

	echo "Remediation passed: The group owner of the file $crontabFile is root."

else

	sudo chown root:root $crontabFile

	checkCrontabGrp=$(stat -c "%G" "$crontabFile")

	if [ $checkCrontabGrp = "root" ]

	then

        	:

	else

		echo "It seems as if an error has occured and that the group owner of the $crontabFile file cannot be set as root instead."

	fi

fi



echo "Remediation for setting permissions on /etc/crontab completed."



#9.5

#Check if the correct permissions has been set for /etc/cron.XXXX and change them if they are not

patchCronHDWMPerm(){

        local cronHDWMType=$1

        local cronHDWMFile="/etc/cron.$cronHDWMType"



	local cronHDWMPerm=$(stat -c "%a" "$cronHDWMFile")

	local cronHDWMRegex="^[0-7]00$"

	if [[ $cronHDWMPerm =~ $cronHDWMRegex ]]

	then

		echo "Remediation passed: The correct permissions has been set for $cronHDWMFile."

	else

		sudo chmod og-rwx $cronHDWMFile

		local checkCronHDWMPerm=$(stat -c "%a" "$cronHDWMFile")

	        local checkCronHDWMRegex="^[0-7]00$"

		if [[ $checkCronHDWMPerm =~ $checkCronHDWMRegex ]]

       		then

                	:

       		else

			echo "It seems as if an error has occured and that the permissions for the $cronHDWMFile file cannot be set as recommended."

		fi

	fi



	local cronHDWMOwn="$(stat -c "%U" "$cronHDWMFile")"

	if [ $cronHDWMOwn = "root" ]

        then

		echo "Remediation passed: The owner of the $cronHDWMFile file is root."

	else

		sudo chown root:root $cronHDWMFile

		local checkCronHDWMOwn="$(stat -c "%U" "$cronHDWMFile")"

	        if [ $checkCronHDWMOwn = "root" ]

	        then

        	        :

	        else

			echo "It seems as if an error has occured and that the owner of the $cronHDWMFile cannot be set as root instead."

		fi



	fi



	local cronHDWMGrp="$(stat -c "%G" "$cronHDWMFile")"

        if [ $cronHDWMGrp = "root" ]

        then

		echo "Remediation passed: The group owner of the $cronHDWMFile file is root."

	else

		sudo chown root:root $cronHDWMFile

		local checkCronHDWMGrp="$(stat -c "%G" "$cronHDWMFile")"

	        if [ $checkCronHDWMGrp = "root" ]

	        then

        	        :

       		else

			echo "It seems as if an error has occured and that the group owner of the $cronHDWMFile cannot be set to root instead."

		fi

	fi

}



patchCronHDWMPerm "hourly"

patchCronHDWMPerm "daily"

patchCronHDWMPerm "weekly"

patchCronHDWMPerm "monthly"



echo "Remediation for setting user/group owner and permission on /etc/cron.xxxx completed."



#9.6

#Check if the permissions has been set correctly for /etc/cron.d and set them right if they are not

cronDFile="/etc/cron.d"

cronDPerm=$(stat -c "%a" "$cronDFile")

cronDRegex="^[0-7]00$"

if [[ $cronDPerm =~ $cronDRegex ]]

then

	echo "Remediation passed: The correct permissions has been set for $cronDFile."

else

	sudo chmod og-rwx $cronDFile

	checkCronDPerm=$(stat -c "%a" "$cronDFile")

	checkCronDRegex="^[0-7]00$"

	if [[ $checkCronDPerm =~ $checkCronDRegex ]]

	then

		:

	else

		echo "It seems as if an error has occured and that the recommended permissions for the $cronDFile file cannot be configured."

	fi



fi



cronDOwn=$(stat -c "%U" "$cronDFile")

if [ $cronDOwn = "root" ]

then

	echo "Remediation passed: The owner of the $cronDFile file is root."

else

        sudo chown root:root $cronDFile

	checkCronDOwn=$(stat -c "%U" "$cronDFile")

	if [ $checkCronDOwn = "root" ]

	then

        	:

	else

		echo "It seems as if an error has occured and that the owner of the $cronDFile cannot be set as root instead."

	fi

fi



cronDGrp=$(stat -c "%G" "$cronDFile")

if [ $cronDGrp = "root" ]

then

	echo "Remediation passed: The group owner of the $cronDFile file is root."

else

	sudo chown root:root $cronDFile

	checkCronDGrp=$(stat -c "%G" "$cronDFile")

	if [ $checkCronDGrp = "root" ]

	then

        	:

	else

		echo "It seems as if an error has occured and that the group owner of the $cronDFile cannot be set as root instead."

	fi

fi



echo "Remediation for setting user/group owner and permission on /etc/cron.d completed."



#9.7

#Check if /etc/at.deny is deleted and that a /etc/at.allow exists and check the permissions of the /e$

atDenyFile="/etc/at.deny"

if [ -e "$atDenyFile" ]

then

    	sudo rm $atDenyFile

else

    	echo "Remediation passed: $atDenyFile is deleted or does not exist."

fi



atAllowFile="/etc/at.allow"

if [ -e "$atAllowFile" ]

then

    	atAllowPerm=$(stat -c "%a" "$atAllowFile")

        atAllowRegex="^[0-7]00$"

        if [[ $atAllowPerm =~ $atAllowRegex ]]

        then

            	echo "Remediation passed: The correct permissions has been set for $atAllowFile."

        else

            	sudo chmod og-rwx $atAllowFile

		checkAtAllowPerm=$(stat -c "%a" "$atAllowFile")

	        checkAtAllowRegex="^[0-7]00$"

	        if [[ $checkAtAllowPerm =~ $checkAtAllowRegex ]]	

	        then

        	        :

        	else

			echo "It seems as if an error has occured and the recommended permissions cannot be set for the $atAllowFile  file."

		fi

        fi



	atAllowOwn=$(stat -c "%U" "$atAllowFile")

        if [ $atAllowOwn = "root" ]

        then

            	echo "Remediation passed: The owner of the $atAllowFile is root."

        else

            	sudo chown root:root $atAllowFile

		checkAtAllowOwn=$(stat -c "%U" "$atAllowFile")

	       	if [ $checkAtAllowOwn = "root" ]

	       	then

			:

		else

			echo "It seems as if an error has occured and that the owne of the $overallCounter file cannot be set as root instead."

		fi

        fi



	atAllowGrp=$(stat -c "%G" "$atAllowFile")

        if [ $atAllowGrp = "root" ]

        then

            	echo "Remediation passed: The group owner of the $atAllowFile is root."

        else

            	sudo chown root:root $atAllowFile

		checkAtAllowGrp=$(stat -c "%G" "$atAllowFile")

	        if [ $checkAtAllowGrp = "root" ]

	        then

	                :

        	else

			echo "It seems as if an error has occured and that the group owner of the $atAllowFile file cannot as set to root instead."

		fi

        fi

else

    	touch $atAllowFile

	sudo chmod og-rwx $atAllowFile

        checkAtAllowPerm2=$(stat -c "%a" "$atAllowFile")

        checkAtAllowRegex2="^[0-7]00$"

        if [[ $checkAtAllowPerm2 =~ $checkAtAllowRegex2 ]]

        then

		:

	else

		echo "It seems as if an error has occured and the recommended permissions cannot be configured for the $atAllowFile file."

	fi

	

	sudo chown root:root $atAllowFile

        checkAtAllowOwn2=$(stat -c "%U" "$atAllowFile")

        if [ $checkAtAllowOwn2 = "root" ]

        then

               	:

       	else

                echo "It seems as if an error has occured and that the owner of the $atAllowFile file cannot be set as root instead"

       	fi	



	sudo chown root:root $atAllowFile

        checkAtAllowGrp2=$(stat -c "%G" "$atAllowFile")

        if [ $checkAtAllowGrp2 = "root" ]

        then

		:

	else

		echo "It seems as if an error has occured and that the group owner of the $atAllowFile file cannot be set as root instead."

	fi

fi



echo "Remediation for restricting at daemon completed."



#9.8

#Check if /etc/cron.deny is deleted and that a /etc/cron.allow exists and check the permissions, configure as recommended if found to have not been configured correctly

cronDenyFile="/etc/cron.deny"

if [ -e "$cronDenyFile" ]

then

    	sudo rm $cronDenyFile

else

    	echo "Remediation passed: $cronDenyFile is deleted or does not exist."

fi



cronAllowFile="/etc/cron.allow"

if [ -e "$cronAllowFile" ]

then

        cronAllowPerm=$(stat -c "%a" "$cronAllowFile")

        cronAllowRegex="^[0-7]00$"

       	if [[ $cronAllowPerm =~ $cronAllowRegex ]]

    	then

                echo "Remediation passed: The correct permissions for $cronAllowFile has been configured."

        else

            	sudo chmod og-rwx $cronAllowFile

               	checkCronAllowPerm=$(stat -c "%a" "$atAllowFile")

            	checkCronAllowRegex="^[0-7]00$"

               	if [[ $checkCronAllowPerm =~ $checkCronAllowRegex ]]

               	then

                       	:

               	else

                        echo "It seems as if an error has occured and the recommended permissions cannot be configured for the $cronAllowFile file."

                fi

       	fi



	cronAllowOwn=$(stat -c "%U" "$cronAllowFile")

        if [ $cronAllowOwn = "root" ]

        then

            	echo "Remedation passed: The owner of the $cronAllowFile is root."

        else

            	sudo chown root:root $cronAllowFile

                checkCronAllowOwn=$(stat -c "%U" "$cronAllowFile")

                if [ $checkCronAllowOwn = "root" ]

                then

                    	:

                else

                        echo "It seems as if an error has occured and that the owner of the $cronAllowFile file cannot be set as root instead."

                fi

        fi



	cronAllowGrp=$(stat -c "%G" "$cronAllowFile")

        if [ $cronAllowGrp = "root" ]

        then

            	echo "Remediation passed: The group owner of the $cronAllowFile is set to root."

        else

            	sudo chown root:root $cronAllowFile

                checkCronAllowGrp=$(stat -c "%G" "$cronAllowFile")

                if [ $checkCronAllowGrp = "root" ]

                then

                    	:

                else

                        echo "It seems as if an error has occured and that the group owner of the $cronAllowFile cannot be set as root instead."

                fi

        fi

else

	touch $cronAllowFile

        sudo chmod og-rwx $cronAllowFile

        checkCronAllowPerm2=$(stat -c "%a" "$cronAllowFile")

        checkCronAllowRegex2="^[0-7]00$"

        if [[ $checkCronAllowPerm2 =~ $checkCronAllowRegex2 ]]

        then

            	:

        else

                echo "It seems as if an error has occured and the recommended permissions cannot be configured for the $cronAllowFIle file."

        fi



        sudo chown root:root $cronAllowFile

        checkCronAllowOwn2=$(stat -c "%U" "$cronAllowFile")

        if [ $checkCronAllowOwn2 = "root" ]

        then

            	:

        else

                echo "It seems as if an error has occured and that the owner of the $cronAllowFile cannot be set as root instead"

        fi



	sudo chown root:root $cronAllowFile

	checkCronAllowGrp2=$(stat -c "%G" "$cronAllowFile")

        if [ $checkCronAllowGrp2 = "root" ]

        then

            	:

        else

		echo "It seems as if an error has occured and that the group owner of the $cronAllowFile cannot be set as root instead."

	fi

fi



echo "Remediation for restricting at/cron to authorized users completed."





#!/bin/bash



#10.1

remsshprotocol=`grep "^Protocol 2" /etc/ssh/sshd_config`

if [ "$remsshprotocol" != "Protocol 2" ]

then

	sed -ie "s/.*Protocol.*/Protocol 2/" /etc/ssh/sshd_config

fi



echo "Remediation for setting of SSH Protocol completed."



#10.2

remsshloglevel=`grep "^LogLevel" /etc/ssh/sshd_config`

if [ "$remsshloglevel" != "LogLevel INFO" ]

then

	sed -ie "s/.*LogLevel.*/LogLevel INFO/" /etc/ssh/sshd_config

fi



echo "Remediation for setting LogLevel to INFO completed."



#10.3

remdeterusergroupownership=`grep "^LogLevel" /etc/ssh/sshd_config`

if [ -z "$remdeterusergroupownership" ]

then

	chown root:root /etc/ssh/sshd_config

	chmod 600 /etc/ssh/sshd_config

fi



echo "Remediation for setting permissions completed."





#10.4

remsshx11forwarding=`grep "^X11Forwarding" /etc/ssh/sshd_config`

if [ "$remsshx11forwarding" != "X11Forwarding no" ]

then

	sed -ie "s/X11Forwarding.*yes/X11Forwarding no/" /etc/ssh/sshd_config

fi



echo "Remediation for disabling SSH X11 Forwarding completed."



#10.5 

maxauthtries=`grep "^MaxAuthTries 4" /etc/ssh/sshd_config`

if [ "$maxauthtries" != "MaxAuthTries 4" ]

then

	sed -ie "s/.*MaxAuthTries.*/MaxAuthTries 4/" /etc/ssh/sshd_config

fi



echo "Remediation for setting SSH MaxAuthTries to 4 or less completed."



#10.6

ignorerhosts=`grep "^IgnoreRhosts" /etc/ssh/sshd_config`

if [ "$ignorerhosts" != "IgnoreRhosts yes" ]

then

	sed -ie "s/.*IgnoreRhosts.*/IgnoreRhosts yes/" /etc/ssh/sshd_config

fi



echo "Remediation for setting SSH IgnoreRhosts to yes completed."



#10.7

hostbasedauthentication=`grep "^HostbasedAuthentication" /etc/ssh/sshd_config`

if [ "$hostbasedauthentication" != "HostbasedAuthentication no" ]

then

	sed -ie "68d" /etc/ssh/sshd_config

	sed -ie "68iHostbasedAuthentication no" /etc/ssh/sshd_config

fi



echo "Remediation for setting SSH HostbasedAuthentication to no completed."



#10.8

remsshrootlogin=`grep "^PermitRootLogin" /etc/ssh/sshd_config`

if [ "$remsshrootlogin" != "PermitRootLogin no" ]

then

	sed -ie "48d" /etc/ssh/sshd_config

	sed -ie "48iPermitRootLogin no" /etc/ssh/sshd_config

fi



echo "Remediation for disabling SSH Root Login completed."



#10.9 

remsshemptypswd=`grep "^PermitEmptyPasswords" /etc/ssh/sshd_config`

if [ "$remsshemptypswd" != "PermitEmptyPasswords no" ]

then

	sed -ie "s/.*PermitEmptyPasswords.*/PermitEmptyPasswords no/" /etc/ssh/sshd_config

fi



echo "Remediation for setting SSH PermitEmptyPasswords to no completed."



#10.10

remsshcipher=`grep "Ciphers" /etc/ssh/sshd_config`

if [ "$remsshcipher" != "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" ]

then

	sed -ie "s/.*Ciphers.*/Ciphers aes128-ctr,aes192-ctr,aes256-ctr/" /etc/ssh/sshd_config

fi



echo "Remediation for using only approved cipher in counter mode completed."



#10.11 

remsshcai=`grep "^ClientAliveInterval" /etc/ssh/sshd_config`

remsshcacm=`grep "^ClientAliveCountMax" /etc/ssh/sshd_config`



if [ "$remsshcai" != "ClientAliveInterval 300" ]

then

	sed -ie "s/.*ClientAliveInterval.*/ClientAliveInterval 300/" /etc/ssh/sshd_config

fi



if [ "$remsshcacm" != "ClientAliveCountMax 0" ]

then

	sed -ie "s/.*ClientAliveCountMax.*/ClientAliveCountMax 0/" /etc/ssh/sshd_config

fi



echo "Remediation for setting idle timeout interval for user login completed."



#10.12

remsshalwusrs=`grep "^AllowUsers" /etc/ssh/sshd_config`

remsshalwgrps=`grep "^AllowGroups" /etc/ssh/sshd_config`

remsshdnyusrs=`grep "^DenyUsers" /etc/ssh/sshd_config`

remsshdnygrps=`grep "^DenyGroups" /etc/ssh/sshd_config`



if [ -z "$remsshalwusrs" -o "$remsshalwusrs" == "AllowUsers[[:space:]]" ]

then

	echo "AllowUsers user1" >> /etc/ssh/sshd_config

fi



if [ -z "$remsshalwgrps" -o "$remsshalwgrps" == "AllowUsers[[:space:]]" ]

then

	echo "AllowGroups group1" >> /etc/ssh/sshd_config

fi



if [ -z "$remsshdnyusrs" -o "$remsshdnyusrs" == "AllowUsers[[:space:]]" ]

then

	echo "DenyUsers user2 user3" >> /etc/ssh/sshd_config

fi



if [ -z "$remsshdnygrps" -o "$remsshdnygrps" == "AllowUsers[[:space:]]" ]

then

	echo "DenyGroups group2" >> /etc/ssh/sshd_config

fi



echo "Remediation for limiting access via SSH completed."



#10.13

remsshbanner=`grep "Banner" /etc/ssh/sshd_config | awk '{ print $2 }'`



if [ "$remsshbanner" != "/etc/issue.net" -o "$remsshbanner" != "/etc/issue" ]

then

	sed -ie "s/.*Banner.*/Banner \/etc\/issue.net/" /etc/ssh/sshd_config

fi



echo "Remediation for setting SSH Banner completed."#!/bin/bash



#11.1

checkPassAlgo=$(authconfig --test | grep hashing | grep sha512)

checkPassRegex=".*sha512"

if [[ $checkPassAlgo =~ $checkPassRegex ]]

then

    	echo "The password hashing algorithm is set to SHA-512 as recommended."

else

    	authconfig --passalgo=sha512 --update

	doubleCheckPassAlgo2=$(authconfig --test | grep hashing | grep sha512)

	doubleCheckPassRegex2=".*sha512"

	if [[ $doubleCheckPassAlgo2 =~ $doubleCheckPassRegex2 ]]

	then

    		echo "The password hashing algorithm is set to SHA-512 as recommended."

		cat /etc/passwd | awk -F: '($3 >= 1000 && $1 != "test") { print $1 }' | xargs -n 1 chage -d 0

		if [ $? -eq 0 ]

		then

			echo "Users will be required to change their password upon the next log in session."

		else

			echo "It seems as if error has occured and that the userID cannot be immediately expired. After a password hashing algorithm update, it is essential to ensure that all the users have changed their passwords."

		fi

	else

		echo "It seems as if an error has occured and the password hashing algorithm cannot be set as SHA-512."

	fi

fi



echo "Remediation for setting password hashing algorithm to SHA-512 completed."





#11.2

pampwquality=$(grep pam_pwquality.so /etc/pam.d/system-auth)

pampwqualityrequisite=$(grep "password    requisite" /etc/pam.d/system-auth)

correctpampwquality="password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type="

if [[ $pampwquality == $correctpampwquality ]]

then

	echo "No remediation needed."

else

	if [[ -n $pampwqualityrequisite ]]

	then

		sed -i 's/.*requisite.*/password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=/' /etc/pam.d/system-auth

	else

		echo $correctpampwquality >> /etc/pam.d/system-auth

	fi

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

	echo "No Remediation needed."

else

	sed -i -e 's/.*minlen.*/# minlen = 14/' -e 's/.*dcredit.*/# dcredit = -1/' -e  's/.*ucredit.*/# ucredit = -1/' -e 's/.*ocredit.*/# ocredit = -1/' -e 's/.*lcredit.*/# lcredit = -1/' /etc/security/pwquality.conf

fi



echo "Remediation for setting password parameters completed."





#11.3

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

	echo "No remediation needed."

elif [[ $faillocksystem == "$correctpamauth" && $faillockpassword != "$correctpamauth" ]]

then

	if [[ -n $faillockpassword ]]

	then

		sed -i '/pam_faillock.so/d' /etc/pam.d/password-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

	else

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

	fi

elif [[ $faillocksystem != "$correctpamauth" && $faillockpassword == "$correctpamauth" ]]

then

	if [[ -n $faillocksystem ]]

	then

		sed -i '/pam_faillock.so/d' /etc/pam.d/system-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

	else

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

	fi

else

	if [[ -n $faillocksystem && -z $faillockpassword ]]

	then

		sed -i '/pam_faillock.so/d' /etc/pam.d/system-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

	elif [[ -z $faillocksystem && -n $faillockpassword ]]

	then

		sed -i '/pam_faillock.so/d' /etc/pam.d/password-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

	elif [[ -n $faillocksystem && -n $faillockpassword ]]

	then

		sed -i '/pam_faillock.so/d' /etc/pam.d/system-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

		sed -i '/pam_faillock.so/d' /etc/pam.d/password-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

	else

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/system-auth

		sed -i -e '5i auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900' -e '7i auth        [default=die] pam_faillock.so authfail audit deny=5' -e '8i auth        sufficient    pam_faillock.so authsucc audit deny=5' -e '10i account     required      pam_faillock.so' /etc/pam.d/password-auth

	fi

fi



echo "Remediation for setting lockout for failed password attempts completed."





#11.4

pamlimitpw=$(grep "remember" /etc/pam.d/system-auth)

existingpamlimitpw=$(grep "password.*sufficient" /etc/pam.d/system-auth)

if [[ $pamlimitpw == *"remember=5"* ]]

then

	echo "No remediation needed."

else

	if [[ -n $existingpamlimitpw ]]

	then

		sed -i 's/password.*sufficient.*/password    sufficient    pam_unix.so sha512 shadow nullok remember=5 try_first_pass use_authtok/' /etc/pam.d/system-auth

	else

		sed -i '/password/a password sufficient pam_unix.so remember=5' /etc/pam.d/system-auth

	fi

fi 



echo "Remediation for limiting password use completed."





#11.5

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



read -d '' correctsyscon << "BLOCKED"

vc/1

tty1

BLOCKED





if [ $systemConsoleCounter != 2 ]

then

	echo "$correctsyscon" > /etc/securetty

else

	echo "No remediation needed."

fi



echo "Remediation for restricting root login to system console completed."





#11.6

pamsu=$(grep pam_wheel.so /etc/pam.d/su | grep required)

if [[ $pamsu =~ ^#auth.*required ]]

then

	sed -i 's/#.*pam_wheel.so use_uid/auth            required        pam_wheel.so use_uid/' /etc/pam.d/su

else

	echo "No remediation needed."

fi



pamwheel=$(grep wheel /etc/group)

if [[ $pamwheel =~ ^wheel.*root ]]

then

	echo "No remediation is needed."

else

	usermod -aG wheel root

fi



echo "Remediation for restricting access to the su command completed."
