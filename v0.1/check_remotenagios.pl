#!/usr/bin/perl
# Coded by: @errecepe
# Start Date: 2016/10/26
# End Date v0.1 2016/10/29
#
# usage: check_remotenagios.pl nagioshost nagioshost_user nagioshost_password host service
#

#add command on nagios as
# 
#	name:		check_command
#	command:	$USER1$/check_remotenagios.pl $ARG1$ $ARG2$ $ARG3$ "$ARG4$" "$ARG5$"
#

use HTML::Parser(); 

$STATE_OK = 0;
$STATE_WARNING = 1; 
$STATE_CRITICAL = 2;
$STATE_ERROR = 255;

#basic params

if (@ARGV[0] eq "--help"){showhelp();exit $STATE_ERROR;}
if (@ARGV[0] eq "--version"){showversion();exit $STATE_ERROR;}

#if less than 5 parameters, show help and exit
if ($#ARGV + 1 < 5) {
	showhelp();
	exit $STATE_ERROR;
}

$NAGIOSREMOTEHOST=@ARGV[0];
$NAGIOSUSER=@ARGV[1];
$NAGIOSPASSWORD=@ARGV[2];
$HOST=@ARGV[3];
$HOST=join("%20", split(" ", $HOST)); #replace spaces for %20 for correct params url syntax calling
$SERVICE=@ARGV[4];
$SERVICE=join("%20", split(" ", $SERVICE)); #replace spaces for %20 for correct params url syntax calling


# curl remote nagios
$RAWHTML=`echo 'user=$NAGIOSUSER:$NAGIOSPASSWORD'|curl -s -K - "http://$NAGIOSREMOTEHOST/nagios/cgi-bin/extinfo.cgi?type=2&host=$HOST&service=$SERVICE"`;
#comment previous line and uncomment next for execute this script under Windows  
#$RAWHTML=`echo user=$NAGIOSUSER:$NAGIOSPASSWORD|curl -s -K - "http://$NAGIOSREMOTEHOST/nagios/cgi-bin/extinfo.cgi?type=2&host=$HOST&service=$SERVICE"`;
#


#get state service from div in HTML source from check remote
$estaok=index($RAWHTML,'serviceOK');
if ($estaok==-1){
		$estawarning=index($RAWHTML,'serviceWARNING');
		if ($estawarning==-1){
		$estaerror=index($RAWHTML,'serviceCRITICAL');
			if ($estaerror==-1){ $resSTATE = $STATE_ERROR ; }else{ $resSTATE = $STATE_CRITICAL ;}
		}
		else
		{
		$resSTATE=$STATE_WARNING;
		}
	}
	else
	{
		$resSTATE=$STATE_OK;
	}
#end 	

#search state info
$posinfo=index($RAWHTML,'Status Information:')+44	; #44 caracteres contando el codigo html que devuelve nagios via web, podría variar segun cliente, funciona ok con core4
$posinfoend=index($RAWHTML,'</TD>',$posinfo)	; #cojo el texto entre $posinfo y el siguiente </td>
$STATUS_INFO = substr($RAWHTML,$posinfo, $posinfoend-$posinfo);
#end search state info

#search performance data
$ppdatainfo=index($RAWHTML,'Performance Data:')+42	; #44 caracteres contando el codigo html que devuelve nagios via web, podría variar segun cliente, funciona ok con core4
$ppdataend=index($RAWHTML,'</TD>',$ppdatainfo)	; #cojo el texto entre $posinfo y el siguiente </td>
$PP_DATA = substr($RAWHTML,$ppdatainfo, $ppdataend-$ppdatainfo-51); #no tengo claro de donde sale el 51
#end search performance data

#finally show error or correct info, and return a correct state code for nagios, and exit
if ( $resSTATE == $STATE_ERROR ) 
	{
	print "UNKNOWN ERROR (nagios server incorrect, credentials incorrect, or host+service doesnt exist)\n"; 
	exit $STATE_ERROR;
	}
	else
	{
	print "$STATUS_INFO |$PP_DATA\n"; 
	exit $resSTATE;
	}

#Help command
sub showhelp()
{
	showversion();
	print "\nGet's remote nagios host and service status value. Useful for Nagios Distributed Environment without installing extras on Main Nagios server\n";
	print "\n";
	print "usage:\n";
	print "  check_remotenagios.pl [remote_nagios_host] [nagios_user] [password] [host] [service]\n";
	print "Where:\n";
	print "  [remote_nagios_host]	= ip address of remote nagios server to check\n";
	print "  [nagios_user]		= nagios user\n";
	print "  [password]		= nagios user password\n";
	print "  [host]		= name of remote host in nagios\n";
	print "  [service]		= name of remote service in nagios\n";
	print "\nFor example the command:\n";
	print "  ./check_remotenagios.pl 192.168.1.50 nagiosadmin pa55w0rd localhost SSH\n";
	print "Will check service 'SSH' on host 'localhost' on remote server nagios with IP:192.168.1.50 using nagiosadmin with pa55w0rd as password\n";
}

#Version command
sub showversion()
{
	print "check_remotenagios.pl v0.1  by \@errecepe more info at https://github.com/errecepe/check_remotenagios.pl 2016/10/28 \n";
}