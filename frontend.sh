#!/bin/bash

source ./common.sh

check_root

dnf module disable nginx -y &>> $logfile
VALIDATE $? "DISABLING nginx"

dnf module enable nginx:1.24 -y &>> $logfile
VALIDATE $? "ENABLING nginx 20"

dnf install nginx -y &>> $logfile
VALIDATE $? "INSTALLING nginx"

systemctl enable nginx &>> $logfile
VALIDATE $? "ENABLE nginx"

systemctl start nginx &>> $logfile
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "removing default code"




curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip 
VALIDATE $? "downloading nginx html code"


cd /usr/share/nginx/html  &>> $logfile
VALIDATE $? "CHANGING DIRECTORY"



unzip /tmp/frontend.zip &>> $logfile
VALIDATE $? "UNZIPPING DOWNLOADED CODE"

rm -rf /etc/nginx/nginx.conf &>> $logfile
VALIDATE $? "removing default nginx.conf file"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>> $logfile
VALIDATE $? "copying nginx.conf file"

systemctl restart nginx  &>> $logfile
VALIDATE $? "restarting nginx"
