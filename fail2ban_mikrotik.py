#!/usr/bin/python3
#
# Mikrotik Fail2ban script v0.2 #
#				#
#	         by Mauro Fiore	#
#	blog.openskills.it	#
#
import argparse,sys
from tikapy import TikapyClient
from pprint import pprint


parser = argparse.ArgumentParser(description="Fail2Ban Mikrotik Script 0.2")
parser.add_argument('-m', help='Mikrotik ip',required=True)
parser.add_argument('-s', help='Mikrotik API port',required=True)
parser.add_argument('-u', help='Mikrotik API User',required=True)
parser.add_argument('-p', help='Mikrotik API Password',required=True)
parser.add_argument('-a', help='Action: ban or unban',required=True)
parser.add_argument('-i', help='Ip address',required=True)
parser.add_argument('-l', help='address List', required=True)
parser.add_argument('-d', help='dinamic timeout', required=False)
args = parser.parse_args()
 
client = TikapyClient(args.m,int(args.s))

client.login(args.u,args.p)

addresslist="?=list="+args.l
ip="?=address="+args.i
dic=client.talk(['/ip/firewall/address-list/print',ip,addresslist,])

if args.a == "ban":

	if not bool(dic):
		addresslist="=list="+args.l
		ip="=address="+args.i
		if args.d:
			dynamic="dynamic=yes"
			timeout="=timeout="+args.d
			client.talk(['/ip/firewall/address-list/add',addresslist,ip,dynamic,timeout])
		else: 
			client.talk(['/ip/firewall/address-list/add',addresslist,ip,])
		sys.exit(0)
	else:
		print ("IP "+args.i+" in list "+args.l+" already exist")
		sys.exit(1)

elif args.a == "unban":

	if bool(dic):
		for key in dic:
			nid=dic[key].get(".id")
		remid="=.id="+nid	
		client.talk(['/ip/firewall/address-list/remove',remid,])
		sys.exit(0)
	else:
		print ("IP "+args.i+" in list "+args.l+" doesn't exist")
		sys.exit(1)
else:
	sys.exit(1)
