#!/bin/bash



#getting domain name from the user
domain=$1
if [ "$domain" == "" ];
then 
	echo "Invalid use of command ex: ./countryroute.sh www.google.com"
	exit;
fi


echo "maximum hopcount = 30"
printf "%-10s %-10s %-10s %-20s %-10s\n" "HOP" "RTT" "COUNTRY" "IP-ADDRESS" "DOMAIN-NAME"

previousIp=""	  

#Go through the route until it finds the destination
for i in {1..30};
do 
ipaddress="`ping -t $i -c 1 $domain | grep -o -m 2 '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | tail -1`";

if [ "$ipaddress" == "" ];
then
	ipaddress="***.***.***.***"
fi

#check whether destination arrived or not
if [ "$ipaddress" == "$previousIp" ];
then
 echo "-------------------"
 break;
fi


#save whois 
whoisOutput=`whois $ipaddress`

country=`echo "$whoisOutput" | grep -i "country" | awk '{ print $NF }' | tail -1`

if [ "$country" == "" ];
then
	country="**"
fi


hopcount=$i
domainname=`host $ipaddress | awk '{ print $NF }'`

if [[ "$domainname" == "3(NXDOMAIN)" ]] || [[ "$domainname" == "2(SERVFAIL)" ]];
then
	domainname="*****"
fi



#getting the round trip time 
rtt=`ping -c 3 $ipaddress | tail -1 | awk '{ print $4 }' | cut -d '/' -f 2`

if [ "$rtt" == "" ];
then
	rtt="***"
fi	 
previousIp=$ipaddress
#echo "$previousIp"


printf "%-10s %-10s %-10s %-20s %-10s\n" "$hopcount" "$rtt" "$country" "$ipaddress" "$domainname" 
done
