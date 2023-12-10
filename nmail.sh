#!/bin/bash
#nmail.sh    Author: tundrv0l
#
#A simple bash script that will scan a IP and will email you the results once it is finished.
#Usage: sudo ./nmail.sh [-a IP] [-p PORT] [-e EMAIL] [-h HELP] [-A AGGRESSIVE] [-S STEALTH]


# Check for root
check_for_root () {
    if [ "$EUID" -ne 0 ]; then # Check if user is root
        echo -e "[ERROR] Script must be run with sudo ./nmail.sh or as root"
        exit
    fi
    }

check_for_root


# Load environment variables from .env file
if [[ -f .env ]]; then
    source .env
else
    echo -e "[ERROR] .env file not found. Please run setup.sh first"
    exit
fi

sender_email=$EMAIL_ADDRESS
sender_passwd=$EMAIL_PASSWORD

#Help Menu
script_help () {
    echo -e "\n valid command line arguements are : \n \n -a       Specfies an IP address \n"\
            "\n -p   Specfies a certain port(s),Will just scan normally if left blank \n --email   Specifies a certain email to forward the results too.\n"\
            "\n -A      Enables Aggressive mode \n" "-S    Enables Stealth mode  \n"\
            "\n -h       you're looking at it"
    exit
    }

#Check Args
while getopts a:p:e:h:A:S flag
do
    case "${flag}" in
        a) address=${OPTARG};;
        p) port=${OPTARG};;
        e) email=${OPTARG};;
        h) script_help;;
        A) aggressive=1;;
        S) stealth=1;;
    esac
done
if [ "$1" == "" ]
        then script_help
fi

#Check for an empty port arg, if it is, set the default to 1000.
if [ "$port" == "" ] 
then
    port="1000"   
fi

#Nmap Function
if [ "$stealth" = "1" ]; then
    sudo nmap -sS -p"$port" "$address" -oN nmap-results.txt
elif [ "$aggressive" = "1" ]; then
    sudo nmap -A -T4 -p"$port" "$address" -oN nmap-results.txt
else
    sudo nmap -p"$port" "$address" -oN nmap-results.txt
fi

# Send the results to the specified email
if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then # Regex to check for valid email
    ssmtp -au $sender_email -ap $sender_passwd $email < nmap-results.txt
else
    echo "That is an invalid email address..are you sure its right?"
fi
