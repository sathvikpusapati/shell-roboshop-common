#!/bin/bash

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $logfile
VALIDATE $? "copying rabbitmq repo"

dnf install rabbitmq-server -y &>> $logfile
VALIDATE $? "installing rabbitmq"

systemctl enable rabbitmq-server
VALIDATE $? "enabling  rabbitmq"

systemctl start rabbitmq-server
VALIDATE $? "starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $logfile
VALIDATE $? "creatying roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logfile
VALIDATE $? "setting permission ton roboshop user "

print_total_time