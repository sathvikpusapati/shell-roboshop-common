#!/bin/bash

source ./common.sh

app_name=catalogue

app_setup

nodejs_setup

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile
VALIDATE $? "copying mongo repo file"

dnf install mongodb-mongosh -y &>> $logfile
VALIDATE $? "installing mongodb client"


INDEX=$(mongosh mongodb.thanunenu.space --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")

if [ $INDEX -le 0 ]; then

    mongosh --host $MONGODB_IP </app/db/master-data.js &>> $logfile
    VALIDATE $? "loading master data into mongodb"
else

    echo -e " ALRAEDY DATA LOADED INTO DATA BASE $Y SKIPPING $N"
fi

app_restart

print_total_time
