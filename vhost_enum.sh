#!/bin/bash

function usage() {
        cat << "EOF"



 ██▒   █▓ ██░ ██  ▒█████    ██████ ▄▄▄█████▓   ▓█████  ███▄    █  █    ██  ███▄ ▄███▓▓█████  ██▀███   ▄▄▄      ▄▄▄█████▓ ██▓ ▒█████   ███▄    █ 
▓██░   █▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒   ▓█   ▀  ██ ▀█   █  ██  ▓██▒▓██▒▀█▀ ██▒▓█   ▀ ▓██ ▒ ██▒▒████▄    ▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █ 
 ▓██  █▒░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░   ▒███   ▓██  ▀█ ██▒▓██  ▒██░▓██    ▓██░▒███   ▓██ ░▄█ ▒▒██  ▀█▄  ▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒
  ▒██ █░░░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░    ▒▓█  ▄ ▓██▒  ▐▌██▒▓▓█  ░██░▒██    ▒██ ▒▓█  ▄ ▒██▀▀█▄  ░██▄▄▄▄██ ░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒
   ▒▀█░  ░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░    ░▒████▒▒██░   ▓██░▒▒█████▓ ▒██▒   ░██▒░▒████▒░██▓ ▒██▒ ▓█   ▓██▒  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░
   ░ ▐░   ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░      ░░ ▒░ ░░ ▒░   ▒ ▒ ░▒▓▒ ▒ ▒ ░ ▒░   ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░  ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
   ░ ░░   ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░    ░        ░ ░  ░░ ░░   ░ ▒░░░▒░ ░ ░ ░  ░      ░ ░ ░  ░  ░▒ ░ ▒░  ▒   ▒▒ ░    ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
     ░░   ░  ░░ ░░ ░ ░ ▒  ░  ░  ░    ░            ░      ░   ░ ░  ░░░ ░ ░ ░      ░      ░     ░░   ░   ░   ▒     ░       ▒ ░░ ░ ░ ▒     ░   ░ ░ 
      ░   ░  ░  ░    ░ ░        ░                 ░  ░         ░    ░            ░      ░  ░   ░           ░  ░          ░      ░ ░           ░ 
     ░                                                                                                                                          
                                                                                                                                                                    


Usage: vhost_enum <domain> [filter] [filter_value] [wordlist]


Arguments:
     domain             The target domain to enumerate.
     filter             ffuf filter option, eg -fs or -fc etc
     filter_value       Value for the filter to use
     wordlist           (Optional) Wordlist to use with ffuf. Defaults to subdomains-top1million-20000.txt from SecLists


Options: 
     -h                 Show this help message.

EOF

        exit 0
}

if [[ $# -eq 0 || $1 == "-h" ]]; then
        usage
fi


DOMAIN=$1
FILTER=$2
WORDLIST=${4:-/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-20000.txt}
FILTER_VAL=$3

echo "[+] Enumerating vhosts with Fuff..."
ffuf -u http://$DOMAIN -H "Host: FUZZ.$DOMAIN" -w "$WORDLIST" $FILTER $FILTER_VAL
