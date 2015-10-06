#!/bin/bash


aws ec2 detach-volume --volume-id vol-606f548d

INSTANCE_ID="$(aws ec2 describe-addresses --public-ips 52.2.158.11 --query 'Addresses[*][InstanceId]' --output text)"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID