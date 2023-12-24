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

dnf module disable mysql -y &>>LOGFILE
VALIDATE $? "Disabling MySQL Module"
cd mysql.repo  /etc/yum.repos.d/mysql.repo &>>LOGFILE
VALIDATE $? "Repo file Setup"
dnf install mysql-community-server -y &>>LOGFILE
VALIDATE $? "MySQL Server Installation"
systemctl enable mysqld &>>LOGFILE
VALIDATE $? "System Service Enable"
systemctl start mysqld &>>LOGFILE
VALIDATE $? "System start mysqld"
mysql_secure_installation --set-root-pass RoboShop@1  &>>LOGFILE
VALIDATE $? "Set root password for MySQL"
mysql -uroot -pRoboShop@1 &>>LOGFILE
VALIDATE $? "checking the new password working"