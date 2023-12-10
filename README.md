# nmail

A little bash script I made to automate the network scanning process for compiling reports. 

## Description

This script uses `nmap` to perform network scans and `ssmtp` to send the scan results via email. It supports both stealth and aggressive scanning modes. The email credentials can be configured via environment variables.

## Getting Started

To get started with this project, clone the repository and run the `setup.sh` script to install the necessary dependencies and configure proper credentials. Then, you can run the `nmail.sh` script to perform a network scan and send the results via email.

```shell
git clone
cd nmail.sh
./setup.sh <EMAIL_ADDRESS> <EMAIL_PASSWORD>
./nmail.sh -h
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request.
