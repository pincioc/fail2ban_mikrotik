#!/usr/bin/perl -w
# nagios:-epn

#########################################
#     monitoring fail2ban mikrotik 	#
#	     nagios plugin		#
#					#
#       Mauro - blog.openskills.it	#
#########################################

use lib qw( /usr/lib/nagios/plugins );
use lib qw( /opt/librenms/plugins );
use utils qw(%ERRORS $TIMEOUT &print_revision &support &usage);
use MikroTik;
use Nagios::Plugin::Getopt;
$ng = Nagios::Plugin::Getopt->new(
	usage => 'Usage: %s -H mtik_host -a apiport -u mtik_user -p mtik_passwd -l list_name',
	version => '0.2 [http://blog.openskills.it]',
);
$ng->arg(spec => 'host|H=s', help => "Mikrotik Host", required => 1);
$ng->arg(spec => 'apiport|a=n', help => "API Port", required => 0);
$ng->arg(spec => 'user|u=s', help => "API username", required => 1);
$ng->arg(spec => 'pass|p=s', help => "API password", required => 1);
$ng->arg(spec => 'list|l=s', help => "list name", required => 1);
$ng->getopts;
$Mtik::debug = 0;
if (!length $ng->get('apiport'))
{
	$apiport=8728
}else{
	$apiport=$ng->get('apiport')
}		
if (Mtik::login($ng->get('host'),$ng->get('user'),$ng->get('pass'),$apiport))
	{
	my @cmd = ("/ip/firewall/address-list/print","=where=","?list=".$ng->get('list'));
	my($retval,@results) = Mtik::raw_talk(\@cmd);
	if (@results == 1){
		print "UNKNOWN - List not found \n";
		exit (3);
	}
	my @values;
	my $counter;
	foreach my $result (@results) {
		#printf "$result\n";
		my @cv = split('=', $result);
		if (@cv == 3){ 
			if ($cv[1] eq "disabled" && $cv[2] eq "false"){
				$counter++;
	        	}
  		}
	}
	Mtik::logout;
		print "OK - ".$counter." elements in ".$ng->get('list')." list \n";
		exit (0);
}else{
		print "UNKNOWN - I can't log in to ".$ng->get('host')."\n";
		exit (3);
}
