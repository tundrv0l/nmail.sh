#!/bin/bash
#setup.sh    Author: tundrv0l
#
#A setup script that will throw the email credentials into a .env file, and check if nmap and ssmtp are installed.
#sudo ./setup.sh EMAIL_ADDRESS EMAIL_PASSWORD

#Check for root
check_for_root () {
    if [ "$EUID" -ne 0 ]; then
        echo -e "[ERROR] Script must be run with sudo ./setup.sh or as root"
        exit
    fi
}

check_for_root

EMAIL_ADDRESS=$1
EMAIL_PASSWORD=$2

# Check if email address and password are provided
if [ -z "$EMAIL_ADDRESS" ] || [ -z "$EMAIL_PASSWORD" ]; then
    echo -e "[ERROR] Missing arguments. Usage: sudo ./setup.sh EMAIL_ADDRESS EMAIL_PASSWORD"
    exit
fi

# Throw credentials into .env file
echo -e "EMAIL_ADDRESS=$EMAIL_ADDRESS\nEMAIL_PASSWORD=$EMAIL_PASSWORD" > .env
echo -e "[SUCCESS] Credentials saved to .env file"

# Check if nmap and ssmtp are installed
if ! command -v nmap &> /dev/null || ! command -v ssmtp &> /dev/null; then
    echo "[WARNING] nmap and ssmtp are required but not installed."
    echo "[WARNING] Would you like to install them now? (y/n)"
    read -r install
    if [ "$install" == "y" ] || [ "$install" == "Y" ]; then
        sudo apt-get update # Update apt-get before installing
        sudo apt-get install nmap ssmtp
    else
        echo "[ERROR] nmap and ssmtp are required to run this script. Exiting..."
        exit
    fi
    exit
fi