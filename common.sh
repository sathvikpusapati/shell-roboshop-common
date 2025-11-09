#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

FOLDER="/var/log/shell-roboshop-common"

log_NAME=$( echo $0 | cut -d "." -f1)

MONGODB_IP=mongodb.thanunenu.space

SCRIPT_DIR=/home/ec2-user/shell-roboshop-common

logfile="$FOLDER/$log_NAME.log"

START_TIME=$(date +%s)

echo "SCRIPT executed at : $(date) " 

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

nodejs_setup()
{
    dnf module disable nodejs -y &>> $logfile
    VALIDATE $? "DISABLING NODEJS"

    dnf module enable nodejs:20 -y &>> $logfile
    VALIDATE $? "ENABLING NODEJS 20"

    dnf install nodejs -y &>> $logfile
    VALIDATE $? "INSTALLING NODEJS"

    npm install &>> $logfile
    VALIDATE $? "installing dependencies"
}

java_setup()
{
    dnf install maven -y &>> $logfile
    VALIDATE $? "installing maven"

    mvn clean package &>> $logfile
    VALIDATE $? "packing the package"

    mv target/shipping-1.0.jar shipping.jar  &>> $logfile
    VALIDATE $? "renaming artifact"

}

python_setup()
{
    dnf install python3 gcc python3-devel -y  &>> $logfile
    VALIDATE $? "python installation is"

    pip3 install -r requirements.txt &>> $logfile
VALIDATE $? " installing dependencies "
}
app_setup()
{
    id roboshop &>> $logfile
    if [ $? -ne 0 ]; then

        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $logfile
        VALIDATE $? "adding system user for roboshop"
    else

        echo -e "SYSTEM USER ALRAEDY CREATED $Y SKIPPING....$N"
    fi
    mkdir -p /app &>> $logfile
    VALIDATE $? "CREATING APP DIRECTORY"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
    VALIDATE $? "downloading $app_name application"


    cd /app &>> $logfile
    VALIDATE $? "CHANGING DIRECTORY"

    rm -rf /app/*  &>> $logfile
    VALIDATE $? "removing existing code"

    unzip /tmp/$app_name.zip &>> $logfile
    VALIDATE $? "UNZIPPING DOWNLOADED CODE"
}

systemd_setup()
{
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>> $logfile
    VALIDATE $? "copying $app_name service file"

    systemctl daemon-reload &>> $logfile
    VALIDATE $? "reloading "

    systemctl enable $app_name &>> $logfile
}

app_restart()
{
    systemctl restart $app_name
    VALIDATE $? "restarted $app_name"
}

print_total_time()
{
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e " SCRIPT EXECUTED IN $Y $TOTAL_TIME seconds $N"
}