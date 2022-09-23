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



while getopts i:u: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
	u) user=${OPTARG};;
    esac
done

echo -e "\n${BPurple}RPC Enumeration${NC}"
echo -e "\n${Red}Before running this script make sure you have cloned repository from github. This script may depend on other files and file structure.${NC}"


echo -e "${BWhite}\n\nNMAP scans:${NC}"
echo -e "${BWhite}1) Check if any NFS mount are exposed${NC}"
nmap $ip --script=msrpc-enum

echo -e "${BWhite}\n2) NFS scan${NC}"
nmap -Pn -sV --script=nfs* $ip

echo -e "${BWhite}\n3) rpcinfo${NC}"
nmap -sV -p 111 --script=rpcinfo $ip

echo -e "${BWhite}\n\nOther useful checks:${NC}"
echo -e "${BWhite}1) Connect to an RPC share without a username and password and enumerate privledges${NC}"
rpcclient --user="" --command=enumprivs -N $ip

echo -e "${BWhite}\nConnect to an RPC share with a username and enumerate privledges${NC}"
rpcclient --user="$user" --command=enumprivs $ip

echo -e "${BWhite}\n\n<aside>\n💡 **Privilege escalation**\n\nTake a look of suid if permission denied\nCreate new user and change the suid of user to the correct one:\n\nsudo sed -i -e 's/1001/1014/g' /etc/passwd\n\n</aside>${NC}"






