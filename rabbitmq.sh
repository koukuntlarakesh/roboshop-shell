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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>LOGFILE
VALIDATE $? "Configure YUM Repos from the scripts"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>LOGFILE
VALIDATE $? "configure yum repos for rabbit mq"
dnf install rabbitmq-server -y  &>>LOGFILE
VALIDATE $? "Installing Rabbit MQ Server using dnf"
systemctl enable rabbitmq-server &>>LOGFILE
VALIDATE $? "Enabling the rabbit mq server"
systemctl start rabbitmq-server &>>LOGFILE
VALIDATE $? "Starting the rabbit mq server"
rabbitmqctl add_user roboshop roboshop123 &>>LOGFILE
VALIDATE $? "creating user for rabbit mq"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOGFILE
VALIDATE $? "Setting permissions to user on vhost '/'"
