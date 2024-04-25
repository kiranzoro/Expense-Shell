#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $1 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "Please enter DB Password:"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .... $R FAILURE $N"
    else
        echo -e "$2 ..... $G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run the script with superuser"
else
    echo "You are a superuser"
fi
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? " Disabling Default nodejs"

dnf module install nodejs:20 -y &>> $LOGFILE
VALIDATE $? "Installing Node JS 20 Module"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing NodeJs"


useradd expense
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "Creating User Expense"
else
    "User Already Added ..... $Y Skpiing $N"
fi