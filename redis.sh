#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>> $logfile
VALIDATE $? "DISABLING DEFAULT REDIS"

dnf module enable redis:7 -y &>> $logfile
VALIDATE $? "ENABLING  REDIS 7"

dnf install redis -y &>> $logfile
VALIDATE $? "INSTALLING REDIS"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no'  /etc/redis/redis.conf &>> $logfile
VALIDATE $? "EDITING REDIS CONF FILE"

systemctl enable redis &>> $logfile
VALIDATE $? "ENABLING  REDIS"

systemctl start redis &>> $logfile
VALIDATE $? "STARTING REDIS"

print_total_time
