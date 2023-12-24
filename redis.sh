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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>LOGFILE
VALIDATE $? "Installing remi repository"
dnf module enable redis:remi-6.2 -y &>>LOGFILE
VALIDATE $? "Enabling Redis Module"
dnf install redis -y &>>LOGFILE
VALIDATE $? "Installing Redis Server"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>LOGFILE
VALIDATE $? "Update listen address "
systemctl enable redis &>>LOGFILE
VALIDATE $? "Enabling redis" 
systemctl start redis &>>LOGFILE
VALIDATE $? "Starting redis" 

