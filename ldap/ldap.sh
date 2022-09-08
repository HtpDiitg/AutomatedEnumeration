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



while getopts i:p: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
    esac
done

echo -e "\n${BPurple}LDAP Enumeration${NC}"


echo -e "${BWhite}\n\nNMAP scan${NC}"
echo -e "\n${BWhite}nmap $ip -n -sV --script 'ldap* and not brute'${NC}"
nmap $ip -n -sV --script "ldap* and not brute" -p $port

echo -e "${BWhite}\nldapsearch -h $ip -x -s base${NC}"
ldapsearch -h $ip -x -s base


echo -e "${BWhite}\n\nUseful information${NC}"
echo -e "\nldapsearch -h $ip -x -D '<DOMAIN>\<USER>' -w '<PASSWORD>' -b 'DC=<1_SUBDOMAIN>,DC=<TDL>'\n\nldapsearch -h 10.10.xx.xx -p 389 -x -s base -b '' '(objectClass=*)' '*' +\n-h ldap server\n-p port of ldap\n-x simple authentication\n-b search base\n-s scope is defined as base\n\nEmail address enumeration\n\ntheharvester -d $ip -b google\n\nGraphical Interface\n\njxplorer"
