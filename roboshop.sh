#!/bin/bash

AMI=ami-0f3c7d07486cad139
SECURITY=sg-07e9d7ca57c23e404

INSTANCES=("web" "cart" "user" "catalogue" "payment" "dispatch" "rabitmq" "shipping" "mongod" "mysql" "redis")
ZONE_ID=Z10166981HVD67IZDDVJN
DOMAIN_NAME=koukuntla.online


for i in "${INSTANCES[@]}"
do
 
   if [ $i == "mongod" ] || [ $i == "mysql" ]||[ $i == "shipping" ]
   then
      INSTANCE_TYPE=t3.small
   else
      INSTANCE_TYPE=t2.micro
   fi
     PRIVATE_IP_ADD=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text) 
                                                                                 
   echo " Instance $i:$PRIVATE_IP_ADD"

aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '
done