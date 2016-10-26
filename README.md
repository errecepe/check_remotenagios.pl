# check_remotenagios.pl
Get's remote nagios host and service status value. Useful for Nagios Distributed Environment without installing extras on Main Nagios server

Get's remote nagios host and service status value. Useful for Nagios Distributed Environment without installing extras on Main Nagios server

usage:
  check_remotenagios.pl [remote_nagios_host] [nagios_user] [password] [host] [service]
Where:
  [remote_nagios_host]  = ip address of remote nagios server to check
  [nagios_user]         = nagios user
  [password]            = nagios user password
  [host]                = name of remote host in nagios
  [service]             = name of remote service in nagios

For example the command:
  ./check_remotenagios.pl 192.168.1.50 nagiosadmin pa55w0rd localhost SSH
Will check service 'SSH' on host 'localhost' on remote server nagios with IP:192.168.1.50 using nagiosadmin with pa55w0rd as password

in development..
