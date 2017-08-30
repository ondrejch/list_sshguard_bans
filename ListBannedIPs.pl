#!/usr/bin/perl
# Lists banned IPs from sshguard
# Ondrej Chvala, ondrejch@gmail.com

# Whois field of interest. NetName is another useful one.
$myfield = 'descr:';

# Get list of banned IPs
@iplist =`sudo iptables -L sshguard -n | awk '/DROP/{print \$4;}'`;

# Whois lookup and print results
$i=0;
foreach $ip (@iplist) {
	chomp $ip;
	$whodata = `whois $ip | grep -i $myfield | head -n1 | sed -e s/$myfield//g`;
	print $i++,"\t", $ip,"\t",$whodata;
}

