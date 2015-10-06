#!/bin/bash
# VERY IMPORTANT: UNOUNT YOUR /DATA BEFORE DETACHING VOLUME!!!

echo -n "YO DAWG!! did you umount your /data [y/n]: "
read answer



if [[ "$answer" == "y" ]]; then
	aws ec2 detach-volume --volume-id vol-606f548d

	INSTANCE_ID="$(aws ec2 describe-addresses --public-ips 52.2.158.11 --query 'Addresses[*][InstanceId]' --output text)"
	aws ec2 terminate-instances --instance-ids $INSTANCE_ID
else
	echo 'go umount yo /data dawg!'
	ssh -i "ucb.pem" root@52.2.158.11
	return 1
fi


INSTANCE_ID="$(aws ec2 describe-addresses --public-ips 52.2.158.11 --query 'Addresses[*][InstanceId]' --output text)"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
