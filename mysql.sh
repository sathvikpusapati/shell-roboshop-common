#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>> $logfile
VALIDATE $? "INSTALLING MYSQL SERVER"

systemctl enable mysqld &>> $logfile
VALIDATE $? "ENABLE MYSQL SERVER"

systemctl start mysqld  &>> $logfile
VALIDATE $? "STARTING MYSQL SERVER"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $logfile
VALIDATE $? "SETTING PASSWORD"

print_total_time

