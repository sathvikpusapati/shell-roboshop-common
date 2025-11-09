#!/bin/bash

source ./common.sh

check_root

app_name=shipping

app_setup
java_setup

systemd_setup

dnf install mysql -y &>> $logfile
VALIDATE $? "installing mysql"

mysql -h mysql.thanunenu.space -uroot -pRoboShop@1 -e 'use cities' &>> $logfile

if [ $? -ne 0 ]; then

    mysql -h mysql.thanunenu.space -uroot -pRoboShop@1 < /app/db/schema.sql
    VALIDATE $? "loading schema"

    mysql -h mysql.thanunenu.space -uroot -pRoboShop@1 < /app/db/app-user.sql 
    VALIDATE $? "loading app-data"

    mysql -h mysql.thanunenu.space -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATE $? "loading master data"

else

    echo -e "SHIPPING DATA IS ALREADY LOADE $Y SKIPPING.....$N" | tee -a $logfile
fi

app_restart

print_total_time