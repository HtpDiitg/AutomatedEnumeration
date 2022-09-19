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



while getopts i:u:P: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
	u) user=${OPTARG};;
	P) passs=${OPTARG};;
    esac
done

echo -e "\n${BPurple}POP3 Enumeration${NC}"


echo -e "${BWhite}\n\nBrute force using hydra:${NC}"
echo -e "${BWhite}hydra -l $user -P $passs -f $ip pop3 -V${NC}"
hydra -l $user -P $passs -f $ip pop3 -V

echo -e "${BWhite}\n\nUseful commands\n${NC}"
echo -e "${BWhite}Read email${NC}"
echo -e "telnet $ip 110\n\nUSER $user\nPASS $password\nLIST\nRETR <MAIL_NUMBER>\nQUIT"

echo -e "${BWhite}\n\nCommands:${NC}"
echo -e "USER   Your user name for this mail server\nPASS   Your password.\nQUIT   End your session.\nSTAT   Number and total size of all messages\nLIST   Message# and size of message\nRETR message#  Retrieve selected message\nDELE message#  Delete selected message\nNOOP   No-op. Keeps you connection open.\nRSET   Reset the mailbox. Undelete deleted messages.\n\nLIST"

