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



while getopts i:p:u:d:P: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
	u) users=${OPTARG};;
	d) domain=${OPTARG};;
	P) passs=${OPTARG};;
    esac
done




echo -e "\n\n${BPurple}SMTP Enumeration${NC}\n\n\n"
nmap $ip -iL email_servers -v --script=smtp-open-relay -p $port

echo -e "\n\n${BWhite}NMAP script scan:${NC}"
nmap $ip --script=smtp-commands,smtp-enum-users,smtp-vuln-cve2010-4344,smtp-vuln-cve2011-1720,smtp-vuln-cve2011-1764 -p $port 

echo -e "\n\n${BWhite}NMAP 'Open Relay' scan:${NC}"

echo -e "\n\n${BWhite}smtp-user-enum:${NC}"
echo -e "\n${BWhite}1) attempt:${NC}"
smtp-user-enum -M VRFY -U $users -t $ip

echo -e "\n${BWhite}2) attempt:${NC}"
smtp-user-enum -M EXPN -D $domain -U $users -t $ip


echo -e "\n\n${BWhite}Brute force using hydra:${NC}"
hydra $ip -L $users -P $passs smtp -V


echo -e "\n\n${BWhite}Useful Information:${NC}"
echo -e "\nConnect to and enumerate users:\n\nnc -nv $ip $port\nVRFY root"

echo -e "\n\n${BWhite}Commands:${NC}\n\nATRN   Authenticated TURNnAUTH   Authentication\nBDAT   Binary data\nBURL   Remote content\nDATA   The actual email message to be sent. This command is terminated with a line that contains only a .\nEHLO   Extended HELO\nETRN   Extended turn\nEXPN   Command to ask the server if a user belongs to a mailing list\nHELO   Identify yourself to the SMTP server.\nHELP   Show available commands\nMAIL   Send mail from email account\nMAIL FROM: me@mydomain.com\nNOOP   No-op. Keeps you connection open.\nONEX   One message transaction only\nQUIT   End session\nRCPT   Send email to recipient\nRCPT TO: you@yourdomain.com\nRSET   Reset\nSAML   Send and mail\nSEND   Send\nSOML   Send or mail\nSTARTTLS\nSUBMITTER      SMTP responsible submitter\nTURN   Turn\nVERB   Verbose\nVRFY   Verify if user exists"























