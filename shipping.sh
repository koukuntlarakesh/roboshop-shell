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

dnf install maven -y 
VALIDATE $? "Installing Maven"

id roboshop
if [ $? -eq 0 ]
then
{
    useradd roboshop &>>LOGFILE
    VALIDATE $? "Creating User if not exit"
}
else
{
     echo -e "User already exists $Y Skipping .... $N "
}
fi 

mkdir /app &>>LOGFILE
VALIDATE $? "creating the app directory"
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>LOGFILE
VALIDATE $? "Downloading Shipping Application from AWS S3 Bucket"
cd /app &>>LOGFILE
VALIDATE $? "moving to app directory"
unzip /tmp/shipping.zip &>>LOGFILE
VALIDATE $? "Extracting the zip file"
mvn clean package &>>LOGFILE
VALIDATE $? "Building the shipping application using mvn command"
mv target/shipping-1.0.jar shipping.jar &>>LOGFILE
VALIDATE $? "moving shipping"
cp /home/centos/roboshop-shell/shipping.service  /etc/systemd/system/shippping.service &>>LOGFILE
VALIDATE $? "copying from shipping services"
systemctl daemon-reload  &>>LOGFILE
VALIDATE $? "loading the service"
systemctl enable shipping &>>LOGFILE
VALIDATE $? "Enabling the service at boot time"
systemctl start shipping &>>LOGFILE
VALIDATE $? "starting shipping"
dnf install mysql -y &>>LOGFILE
VALIDATE $? "Install my sql"
mysql -h mysql.koukuntla.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>LOGFILE
VALIDATE $? "loading the schema"
systemctl restart shipping &>>LOGFILE
VALIDATE $? "Restarting the shipping "
