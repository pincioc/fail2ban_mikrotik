# fail2ban_mikrotik
Fail2ban action and script for mikrotik address-list management

Configure your mikrotik, in this example the internal "secure" network is 192.168.0.0./24

Enable API

 /ip service enable [find name=api]
 /ip service set address=192.168.0.0/24 [find name=api]

Create firewall rule that block all traffic from ip address in address-list fail2ban

 /ip firewall filter add action=drop chain=forward comment="Fail2ban" src-address-list=fail2ban

Create API group

 /user group add name=API policy=read,write,api,!local,!telnet,!ssh,!ftp,!reboot,!policy,!test,!winbox,!password,!web,!sniff,!sensitive,!romon

Create user 

 /user add address=192.168.0.0/24 group=API name=apiuser password=VERYSECUREPASSWORD

Install dependencies

For Ubuntu/Debian

 apt-get install python3-pip

 pip3 install tikapy argparse 



