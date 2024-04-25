#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Downloading fronted.zip"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip

vim /etc/nginx/default.d/expense.conf

cp /home/ec2-user/Expense-Shell/expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx
VALIDATE$? "Resarting nginx"