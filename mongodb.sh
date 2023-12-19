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
    if [ $1 -ne 0]
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

cp mongo.repo  /etc/yum.repos.d/mongo.repo
VALIDATE $? "REPO FILE SETUP"
dnf install mongodb-org -y &>>LOGFILE
VALIDATE $? "MONGODB SETUP"
systemctl enable mongod &>>LOGFILE
VALIDATE $? "MONGOD ENABLED"
systemctl start mongod &>>LOGFILE
VALIDATE $? "MONGODB STARTED"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>LOGFILE
VALIDATE $? "UPDATED  listen address"
systemctl restart mongod &>>LOGFILE
VALIDATE $? "RESTART OF MONGOD"
