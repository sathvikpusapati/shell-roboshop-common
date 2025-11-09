#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

FOLDER="/var/log/SHELL-ROBOSHOP"

log_NAME=$( echo $0 | cut -d "." -f1)


SCRIPT_DIR=/home/ec2-user/shell-ROBOSHOP

logfile="$FOLDER/$log_NAME.log"

START_TIME=$(date +%s)

echo "SCRIPT executed at : $(date) " | tee -a $logfile

sudo mkdir -p $FOLDER

id=$(id -u)

check_root()
{   
    if [ $id -ne 0 ]; then
      echo -e "$R kindly provide root access to proceed $N"
      exit 1
    fi
}

VALIDATE()
{
    if [ $1 -ne 0 ]; then
        echo -e "$2 $R  FAILED $N" | tee -a $logfile
    else
        echo -e "$2 $G  SUCCESS $N" | tee -a $logfile
    fi    
}

print_total_time()
{
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e " SCRIPT EXECUTED IN $Y $TOTAL_TIME seconds $N"
}