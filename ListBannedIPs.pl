#!/usr/bin/perl
# Lists banned IPs from sshguard
# Ondrej Chvala, ondrejch@gmail.com

# Whois field of interest. NetName is another useful one.
$myfield = 'descr';

# Get list of banned IPs
@iplist =`sudo iptables -L sshguard -n | awk '/DROP/{print \$4;}'`;

# Whois lookup and print results
$i = 1;     # Index starts from 1 so it corresponds to iptables rule number
foreach $ip (@iplist) {
	chomp $ip;
	$whodata = `whois $ip | grep -i $myfield | head -n1 | sed -e s/${myfield}:\\ */\\ \\ /g`;
    chomp $whodata;
    if ($whodata eq "") {   # Nothin in $myfield, use address
        $whodata = `whois $ip | grep -i 'Address\\|City\\|state'  -m3 | sed -e s/.*:\\ *//g | sed -e ':a;N;\$!ba;s/\\n/, /g'`;
        chomp $whodata;
    }
	print $i++,"\t", $ip,"\t",$whodata,"\n";
}

