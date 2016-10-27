# check_remotenagios.pl
v0.1 (c)2016 by @errecepe [CC BY-NC-SA] 3.0 license
28/10/2016
-----------------------------------------------------------------------------------------
Description

Get's remote nagios host and service status value. Useful for Nagios Distributed Environment without installing extras on Main Nagios server
-----------------------------------------------------------------------------------------
Basic help

usage: 
	check_remotenagios.pl [remote_nagios_host] [nagios_user] [password] [host] [service] 

Where: 
	[remote_nagios_host] = ip address of remote nagios server to check 
	[nagios_user] = nagios user 
	[password] = nagios user password 
	[host] = name of remote host in nagios 
	[service] = name of remote service in nagios

For example the command: 
	./check_remotenagios.pl 192.168.1.50 nagiosadmin pa55w0rd localhost SSH 
	Will check service 'SSH' on host 'localhost' on remote server nagios with IP:192.168.1.50 using nagiosadmin with pa55w0rd as password

Others params:
	--version	show version
	--help		show help

-----------------------------------------------------------------------------------------
Instalation and configuration:

Step 1:
  In 'main Nagios server' copy in /usr/local/nagios/libexec/ the script file check_remotenagios.pl, and chmod 777 check_remotenagios.pl

Step 2:
  In 'main Nagios server' add a command called: check_remotenagios
  with command: $USER1$/check_remotenagios.pl $ARG1$ $ARG2$ $ARG3$ $ARG4$ $ARG5$

Step 3:
  apply changes, and restart nagios service after verify configuration (usually /usr/local/nagios/bin/nagios -v   /usr/local/nagios/etc/nagios.cfg)

Done! It's ready for use!
The script it's developed using Perl and curl (these tools are usually currently installed in all nagios servers), not need 
extra configurations or installation on main Nagios server.
-----------------------------------------------------------------------------------------
Using command:

Now you can add services using the new command check_remotenagios (or the name you used in Step 2) in your 'main Nagios server'
and configure for get values from a remote nagios server. Obviously the checked host and service must be defined on remote Nagios
server. 

The script will use just curl (need port 80 opened, can check it in'main Nagios server' executing "nmap REMOTE_NAGIOS_IP -p 80") to
connect via http to remote nagios. 

The params in nagios are:

$ARG1$ its ip address of remote nagios server to check [remote_nagios_host]
$ARG2$ its nagios user [nagios_user]
$ARG3$ its nagios user password [password]
$ARG4$ its name of remote host in nagios [host]
$ARG5$ its name of remote service in nagios [service]

You will get the state, and performance data from remote nagios server, so under Nagios XI you will get data for performance graphs.

This script can be used for distribute checks in a complex production environment. Or if you need to use checks using a big cpu load,
can use an external server for distribute cpu load on 'main nagios server' easily.

Tested with Remote nagios core 4 (4.1.1) version, from Nagios XI 5 as main Nagios server.
Supposed to work in any nagios xi or core version, but only with remote core version. 
At the moment dont work with remote Nagios XI servers (working on this feature)
