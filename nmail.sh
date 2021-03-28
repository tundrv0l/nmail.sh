#!/bin/bash
#Nmail.sh    Author: tundrv0l
#
#A simple bash script that will scan a IP and will email you the results once it is finished.
#Usage: sudo ./nmail.sh [-a IP] [-p PORT] [-e EMAIL] [-h- HELP]
#Disclaimer: This is only in version 1.0, so feel free to report any bugs.
#Thanks to Elbee and FishSauce for answering my noob questions. 


#Credentials for Email (CHANGE THESE!!!)
sender_email=SENDER-EMAIL
sender_passwd=EMAIL-PASSWORD




# Root Checker 
check_for_root () {
    if [ "$EUID" -ne 0 ]
      then echo -e "\n\n Script must be run with sudo ./nmappingscript.sh or as root \n"
      exit
    fi
    }

check_for_root
#Help Menu
script_help () {
    echo -e "\n valid command line arguements are : \n \n -a       Specfies an IP address \n"\
            "\n -p   Specfies a certain port(s),Will just scan normally if left blank \n --email   Specfies a certain email to forward the results too.\n"\
            "\n -A-      Enables Aggressive mode \n" "-S-    Enables Stealth mode  \n"\
            "\n -h-       you're looking at it"
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


#Email Function
if [ "$email" == "" ]; then
    echo "That is an invalid email address..are you sure its right?"
else
    ssmtp -au $sender_email -ap $sender_passwd $email < nmap-results.txt
fi
