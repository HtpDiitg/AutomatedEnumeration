#!/bin/bash


NC='\033[0m'		  # No Color

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



while getopts i:p:u:P: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
	u) users=${OPTARG};;
	P) passs=${OPTARG};;
    esac
done


echo -e "${BRed}IMPORTANT!${NC}"
echo -e "${BWhite}Before usage create username and password lists. Provide path to them."
echo -e "\n\n${BPurple}FTP Enumeration\n\n"

echo -e "${BWhite}NMAP basic scan:${NC}"
nmap $ip -p $port -sC -sV

echo -e "\n\n${BWhite}More in-depth scan:${NC}"
nmap --script ftp-* -p $port $ip 


echo -e "\n\n${BWhite}ftp-user-enum.pl:${NC}"
echo -e "${UWhite}1) attempt${NC}"
perl ftp-user-enum.pl -M sol -U $users -t $ip


echo -e "\n${UWhite}2) attempt${NC}"
perl ftp-user-enum.pl -U $users -t $ip


echo -e "\n\n${BWhite}Brute force using hydra:${NC}"
hydra -V -f -L $users -P $passs ftp://$ip -u -vV


echo -e "\n\n${BWhite}Useful commands:\n${NC}send # Send single file\nput # Send one file.\nmput # Send multiple files.\nmget # Get multiple files.\nget # Get file from the remote computer.\nls # list \nmget * # Download everything"

