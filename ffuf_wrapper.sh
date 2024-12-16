#!/bin/bash

function display_banner() {
        cat << "EOF"


  █████▒ █    ██   █████▒  █████▒    █     █░ ██▀███   ▄▄▄       ██▓███   ██▓███  ▓█████  ██▀███  
▓██   ▒  ██  ▓██▒▓██   ▒ ▓██   ▒    ▓█░ █ ░█░▓██ ▒ ██▒▒████▄    ▓██░  ██▒▓██░  ██▒▓█   ▀ ▓██ ▒ ██▒
▒████ ░ ▓██  ▒██░▒████ ░ ▒████ ░    ▒█░ █ ░█ ▓██ ░▄█ ▒▒██  ▀█▄  ▓██░ ██▓▒▓██░ ██▓▒▒███   ▓██ ░▄█ ▒
░▓█▒  ░ ▓▓█  ░██░░▓█▒  ░ ░▓█▒  ░    ░█░ █ ░█ ▒██▀▀█▄  ░██▄▄▄▄██ ▒██▄█▓▒ ▒▒██▄█▓▒ ▒▒▓█  ▄ ▒██▀▀█▄  
░▒█░    ▒▒█████▓ ░▒█░    ░▒█░       ░░██▒██▓ ░██▓ ▒██▒ ▓█   ▓██▒▒██▒ ░  ░▒██▒ ░  ░░▒████▒░██▓ ▒██▒
 ▒ ░    ░▒▓▒ ▒ ▒  ▒ ░     ▒ ░       ░ ▓░▒ ▒  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▓▒░ ░  ░▒▓▒░ ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░
 ░      ░░▒░ ░ ░  ░       ░           ▒ ░ ░    ░▒ ░ ▒░  ▒   ▒▒ ░░▒ ░     ░▒ ░      ░ ░  ░  ░▒ ░ ▒░
 ░ ░     ░░░ ░ ░  ░ ░     ░ ░         ░   ░    ░░   ░   ░   ▒   ░░       ░░          ░     ░░   ░ 
           ░                            ░       ░           ░  ░                     ░  ░   ░     
                                                                                                  


EOF
}



# Function to display the usage message
function usage() {
        display_banner
        cat << "EOF"

Fuff Bash wrapper script

Usage: vhost_enum [action] [hostname] [filter] [filter_value] [options]

Arguments:
     action             Action to perform: "vhost" for vhost enumeration, "dir" for directory brute force.
     domain             The target domain to enumerate.
     filter             ffuf filter option, eg -fs or -fc etc (optional)
     filter_value       Value for the filter to use (optional)

Options: 
     -w <wordlist>      Custom wordlist for ffuf. Defaults to subdomains-top1million-20000.txt for vhost and /usr/share/wordlists/dirb/common.txt for directory brute force.
     -h                 Show this help message.

Examples:
     ./vhost_enum.sh vhost example.com
     ./vhost_enum.sh dir example.com -fs 100 -w /usr/share/wordlists/dirb/common.txt

EOF

    exit 0
}

# Check if no arguments or if -h is passed, then show usage
if [[ $# -eq 0 || $1 == "-h" ]]; then
    usage
fi

# Initialize default wordlists for vhost and directory brute force
DEFAULT_VHOST_WORDLIST="/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-20000.txt"
DEFAULT_DIR_WORDLIST="/usr/share/wordlists/dirb/common.txt"

# Parse arguments
ACTION=$1
HOSTNAME=$2
FILTER=$3
FILTER_VAL=$4
WORDLIST=""  # Empty by default, will set later

# Check if a custom wordlist (-w) is provided
while getopts "w:" opt; do
    case "$opt" in
        w) WORDLIST=$OPTARG ;;
        *) usage ;;
    esac
done

# Validate the action argument
if [[ "$ACTION" != "vhost" && "$ACTION" != "dir" ]]; then
    echo "[!] Invalid action. Please use 'vhost' for vhost enumeration or 'dir' for directory brute force."
    exit 1
fi

# Set the default wordlist based on the action
if [[ "$ACTION" == "vhost" && -z "$WORDLIST" ]]; then
    WORDLIST=$DEFAULT_VHOST_WORDLIST
elif [[ "$ACTION" == "dir" && -z "$WORDLIST" ]]; then
    WORDLIST=$DEFAULT_DIR_WORDLIST
fi

# Function to print output in red
function print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

# Function to print output in blue
function print_blue() {
    echo -e "\033[0;34m$1\033[0m"
}

# Run vhost enumeration with ffuf
display_banner

if [[ "$ACTION" == "vhost" ]]; then
    echo "[+] Enumerating vhosts with Fuff using wordlist: $WORDLIST..."
    ffuf -u http://$HOSTNAME -H "Host: FUZZ.$HOSTNAME" -w "$WORDLIST" $FILTER $FILTER_VAL

fi

# Run directory brute force with ffufi
# display_banner
if [[ "$ACTION" == "dir" ]]; then
    echo "[+] Brute forcing directories with Fuff using wordlist: $WORDLIST..."
    output=$(ffuf -s -u http://$HOSTNAME/FUZZ -w "$WORDLIST" $FILTER $FILTER_VAL)

    # Check if the output is empty
    if [[ -z "$output" ]]; then
        orint_red "[!] No results found for directory brute force."
    else
        print_blue "$output"
    fi
fi
