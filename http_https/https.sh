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



echo -e "\n\n${BPurple}Web Enumeration${NC}"


echo -e "\n\n${BWhite}Discovering directories using gobuster:${NC}"
gobuster dir -u https://$ip/ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories-lowercase.txt –f


echo -e "\n\n${BWhite}Scan ssl:${NC}"
sslscan $ip


echo -e "\n\n${BWhite}Web Crawling using gospider:${NC}"
gospider -d 3 --robots --sitemap -t 5 -s https://$ip:$port/


echo -e "\n\n${BRed}Before running crawleet.py install necessary libraries using crawleetinstaller.sh${NC}"
echo -e "\n${BWhite}Detecting and Exploiting some vulns in Drupal, Joomla, Magento, Moodle, OJS, Strus and Wordpress:${NC}"
python crawleet/crawleet.py -u https://$ip:$port/ -b -d 3 -e jpg,png,css -f -m -s -x html,php,txt -y --threads 10


echo -e "\n\n${BWhite}Scanning Web Site using nikto:${NC}"
nikto -h https://$ip:$port/


echo -e "\n\n${BWhite}Useful Information:${NC}"

echo -e "\nYou may use hydra to brute 'HTTP authentication'"
echo -e "\nOnce you have found all the files, look for backups of all the executable files (“.php”, “.aspx“…). Common variations for naming a backup are:\nfile.ext~, file.ext.bak, file.ext.tmp, file.ext.old, file.bak, file.tmp and file.old"
echo -e "\nIf you discovered Wordpress, use wpscan to find juice info!"








