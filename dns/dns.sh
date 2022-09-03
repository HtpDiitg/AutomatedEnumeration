#!/bin/bash

# No Color

NC='\033[0m'

# Regular Colors

Purple='\033[0;35m'       # Purple
White='\033[0;37m'        # White
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue

# Bold

BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BWhite='\033[1;37m'       # White

# Underline
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UWhite='\033[4;37m'       # White

# Background

On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_White='\033[47m'       # White



while getopts i:d: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        d) domain=${OPTARG};;
    esac
done

echo -e "\n${BPurple}DNS Enumeration${NC}"
echo -e "\n${Red}Before running this script make sure you have cloned repository from github. This script hugely depends on other files and file structure.${NC}"


echo -e "${BWhite}\n\nJust some useful commands:${NC}"
echo -e "${BWhite}1) dnsenum $domain${NC}\n"
dnsenum $domain

echo -e "${BWhite}\n2) dnsrecon -d $domain${NC}"
dnsrecon -d $domain

echo -e "\n${BWhite}3) dnsrecon -d $domain -t axfr${NC}"
dnsrecon -d $domain -t axfr

echo -e "\n${BWhite}4) Check Zone Transfer manually.\n${NC}"

echo -e "\n${BWhite}5) whois $domain${NC}"
whois $domain

echo -e "\n${BWhite}6) whois $ip${NC}"
whois $ip

echo -e "\n${BWhite}7) dig axfr $domain @$ip${NC}"
dig axfr $domain @$ip

echo -e "\n${BWhite}8) Find Name Servers\nhost -t ns $ip${NC}"
host -t ns $ip

echo -e "\n${BWhite}9) Find txt records\nhost -t txt $ip${NC}"
host -t txt $ip

echo -e "\n${BWhite}10) Find mails\nhost -t mx $ip${NC}"
host -t mx $ip

echo -e "\n${BWhite}11) nslookup $domain${NC}"
nslookup $domain

echo -e "\n${BWhite}12) nslookup $ip${NC}"
nslookup $ip

echo -e "\n${BWhite}13) Subdomain bruteforcing using common hostname${NC}"
echo -e "${BWhite}for x in $(cat subd.txt); do host $x.$domain; done${NC}"
for x in $(cat subd.txt); do host $x.$domain; done

echo -e "\n\n${BBlue}Always attempt to do a zone transfer if you know the target domain.${NC}"
