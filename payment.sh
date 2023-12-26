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

dnf install python36 gcc python3-devel -y &>>LOGFILE
VALIDATE $? "Install python"
id roboshop
if [ $? -ne 0 ]
then
{
    useradd roboshop &>>LOGFILE
    VALIDATE $? "Create User roboshop"
}
else
{
    echo -e "User already exits $Y Skipping...$N "
}
fi
mkdir app &>>LOGFILE
VALIDATE $? "creating app directory"
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>LOGFILE
VALIDATE $? "downloading payment file"
cd /app &>>LOGFILE
unzip -q /tmp/payment.zip &>>LOGFILE
VALIDATE $? " Unzipping the file"
pip3.6 install -r requirements.txt &>>LOGFILE
VALIDATE $? " Installing Python Dependencies "
cp  /home/centos/roboshop-shell/payment.service  /etc/systemd/system/payment.service &>>LOGFILE
VALIDATE $? "copying payment service"
systemctl daemon-reload &>>LOGFILE
VALIDATE $? "loading service"
systemctl enable payment &>>LOGFILE
VALIDATE $? "enable payment service"    
systemctl start payment &>>LOGFILE
VALIDATE $? "starting the payment service"
