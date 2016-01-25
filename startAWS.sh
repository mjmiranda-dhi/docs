#!/bin/bash


# launch (availability-zone = us-east-1b, securitygroup = ucb_205_security_group, ami = ucb-postgres)

NEWINSTACEID="$(aws ec2 run-instances --image-id ami-7789cb12 --key ucb --instance-type m3.large --security-group-ids sg-a5e90ec3 --subnet subnet-bcf5bd97 --query 'Instances[*][InstanceId]' --output text)"

check_status=$(aws ec2 describe-instance-status --instance-ids $NEWINSTACEID --query 'InstanceStatuses[*].InstanceState.Name' --output text)


until [ "$check_status" == "running" ]; do
	echo "checking..."
	sleep 1
	check_status=$(aws ec2 describe-instance-status --instance-ids $NEWINSTACEID --query 'InstanceStatuses[*].InstanceState.Name' --output text)
done


# set elastic ip
aws ec2 associate-address --instance-id $NEWINSTACEID --public-ip 52.2.158.11

# attach my volume 
aws ec2 attach-volume --volume-id vol-606f548d --instance-id $NEWINSTACEID --device /dev/sdf

# Go Play!
ssh -i "ucb.pem" root@52.2.158.11
