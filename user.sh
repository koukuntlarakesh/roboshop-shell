#!/bin/bash
ID=$(id -u)
R="\e[31m" #red color
G="\e[32m" #green color
Y="\e[33m" #yellow color
N="\e[0m"  #nomal  
TIMESTAMP=$(date +%F-%H-%M)

LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo -e "Script started excution at $G $TIMESTAMP $N " &>>LOGFILE

if [ $ID -ne 0 ]
then
{
     echo -e "$R YOU ARE NOT ROOT USER $N"
     exit 1
}
else
{
      echo -e " $G YOU ARE ROOT USER $N "
}
fi

VALIDATE()
{
    if [ $1 -ne 0 ] 
    then
    {
        echo -e " $2 ..... $R ERROR $N "
        exit 1
    }
    else
    {
        echo -e " $2 ..... $G SUCCESS $N "
    }
    fi
}

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $?  "Disabling Nodejs"
dnf module enable nodejs:18 -y &>>LOGFILE
VALIDATE $?  "Enabling Nodejs"
dnf install nodejs -y &>>LOGFILE
VALIDATE $?  "Installing Node Js"
id roboshop
if [ $? -ne 0 ]
then 
{
    useradd roboshop 
    VALIDATE $?  "Creating User roboshop"
}
else
{
    echo -e "User roboshop already exists.. $Y Skipping...$N "
}
fi

mkdir /app  &>>LOGFILE
VALIDATE $? "created directory"
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>LOGFILE
VALIDATE $? "Downloading application code"
cd /app  &>>LOGFILE
VALIDATE $? "Moving to app directory"
unzip /tmp/user.zip &>>LOGFILE
VALIDATE $? "Extracting zip file"
npm install &>>LOGFILE
VALIDATE $? "Running npm install in the project folder"
cp /home/centos/roboshop-shell/user.service  /etc/systemd/system/user.service &>>LOGFILE
VALIDATE $? "copying is done" 
systemctl daemon-reload &>>LOGFILE
VALIDATE $? "reload user service" 
systemctl enable user &>>LOGFILE
VALIDATE $? "Enable user service"
systemctl start user &>>LOGFILE
VALIDATE $? "Starting user service"
cp /home/centos/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo &>>LOGFILE
VALIDATE $? "copying mongod"
dnf install mongodb-org-shell -y &>>LOGFILE
VALIDATE $? "install mongo shell"
mongo --host mongod.koukuntla.online </app/schema/user.js &>>LOGFILE
VALIDATE $? "creating database and collections"
