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
        echo -e " $2 ..... $G ERROR $N "
    }
    else
    {
        echo -e " $2 ..... $G SUCCESS $N "
    }
    fi
}

dnf module disable nodejs -y
VALIDATE $?  "Disabling Nodejs"
dnf module enable nodejs:18 -y
VALIDATE $?  "Enabling Nodejs"
dnf install nodejs -y
VALIDATE $?  "Installing Node Js"
useradd roboshop
VALIDATE $? "Creating user"
mkdir /app
VALIDATE $? "created directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Downloading application code"
cd /app  
VALIDATE $? "Moving to app directory"
unzip /tmp/catalogue.zip 
VALIDATE $? "Extracting zip file"
npm install  
VALIDATE $? "Running npm install in the project folder"

