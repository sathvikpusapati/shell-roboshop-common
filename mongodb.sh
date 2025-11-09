#!/bin/bash

source ./common.sh

check_root()

cp  mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "MONGO REPO COPIED"

dnf install mongodb-org -y &>> $logfile
VALIDATE $? "MONGODB INSTALLATION"

systemctl enable mongod &>> $logfile
VALIDATE $? "ENABLE MONGODB"

systemctl start mongod &>> $logfile
VALIDATE $? "START MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $logfile

VALIDATE $? "Allowing remote connection to MONGODB" 

systemctl restart mongod &>> $logfile
VALIDATE $? "MONGODB RESTART" 

print_total_time()