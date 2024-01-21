#!/bin/bash

AMI=ami-0f3c7d07486cad139
SECURITY=sg-07e9d7ca57c23e404

INSTANCES=("web" "cart" "user" "catalogue" "payment" "dispatch" "rabitmq" "shipping" "mongod" "mysql" "redis")

for i in "${INSTANCES[@]}"
do
   if [ $i == "mongod" ] || [ $i == "mysql" ]||[ $i == "shipping" ]
   then
      INSTANCE_TYPE=t3.small
   else
      INSTANCE_TYPE=t2.micro
   fi
   aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY --tag-specifications "ResourceType=instance,Tags=[{Key=webserver,Value= $i}]" 