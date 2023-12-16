#!/bin/bash

TIME=$(date +%F-%H-%M-%S)

LOG="/tmp/$0-$TIME.log"

R="\e[31m"
G="\e[32m"
N="\e[0m"

echo "Script started executing at $TIME"
echo "checking root user are not.....?"

validate(){

 if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}
ID=$(id -u)

if [ $ID -ne 0 ] &>> $LOG
then
    echo -e "you are not a $R root user $N"
    exit 1
else
    echo -e "you are a $G root user $N"
fi

cp mongodb.repo /etc/yum.repos.d/mongo.repo &>> $LOG
validate $? "copied mongodb repo"

dnf install mongodb-org -y &>> $LOG
validate $? "Installing MongoDB"

systemctl enable mongod &>> $LOG
validate $? "Enabling Mongodb"

systemctl start mongod &>> $LOG
validate $? "starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG
validate $? "Remote access to MongoDB"

systemctl restart mongod $>> $LOG
validate $? "Restarting mongodb"