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

dnf install nginx -y &>>LOGFILE
VALIDATE $? "Installing Nginx" 
systemctl enable nginx &>>LOGFILE
VALIDATE $? "Enabling nginx"
systemctl start nginx &>>LOGFILE
VALIDATE $? "Starting nginx"
rm -rf /usr/share/nginx/html/* &>>LOGFILE
VALIDATE $? "Removing default content"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGFILE
VALIDATE $? "Downloading web files"
cd /usr/share/nginx/html &>>LOGFILE
VALIDATE $? "extracting front end content"
unzip /tmp/web.zip &>>LOGFILE
VALIDATE $? "Extracting zip file"
 cp /home/centos/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>LOGFILE
 VALIDATE "Nginx configuration "
 systemctl restart nginx   
 VALIDATE $? "Restarting the nginx"
