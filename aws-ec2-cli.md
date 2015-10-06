##THIS DOCUMENT PROVIDES SOME AWS EC2 CLI COMMANDS. IT IS NOT COMPREHENSIVE. 
I INTEND TO FLESH IT OUT OVER TIME. FOR THE TIME BEING USE IT TO COPYPASTA SOME OFT USED COMMANDS
IT ASSUMES YOU INSTALLED AWS CLI TOOLS. ALL THE COMMANDS ARE RUN FROM A LINUX TERMNAL.##

# get info about all your instances
aws ec2 describe-instances

# launch your instance
# YOU WILL NEED: your ami id, your key (ie ucb.pem), your security group id, and your subnet id. 
# You can get all these when you first created your instance
aws ec2 run-instances --image-id ami-1785fe72 --key ucb --instance-type m3.large --security-group-ids sg-a5e90ec3 --subnet subnet-bcf5bd97

# associate elastic ip (make sure to get the right id from above command output)
aws ec2 associate-address --instance-id i-xxxxx --public-ip 52.2.158.11

# attach your volume (may need to detach automatically attached volume)
aws ec2 describe-volumes

# detach the one that is /dev/sdf
# aws ec2 detach-volume --volume-id vol-xxxxxxx

# (make sure to get the right id from above describe-instances command output)
# the volume id is your EBS volume id
aws ec2 attach-volume --volume-id vol-xxxxxx --instance-id i-xxxxxx --device /dev/sdf

______________

ssh -i "ucb.pem" root@52.2.158.11

mount /dev/xvdf /data

# commented steps were already performed
# /usr/lib/hadoop/libexec/init-hdfs.sh
# sudo -u hdfs hdfs dfs -mkdir /user/ucb
# sudo -u hdfs hdfs dfs -chown ucb /user/ucb

bash start-hadoop.sh

(it's in here: /root/start-hadoop.sh)
# to avoid spark path shenannigans, su <user> first

su ucb
hive

exit;
pyspark




----------
on logout:

(~/.bash_logout) this BS doesn't work	

cd $HOME
bash stop-hadoop.sh
umount /data

# sanity check to make sure your volumen was unmounted:
df -h

exit

# detach your volume
aws ec2 detach-volume --volume-id vol-xxxxx

# terminate your instance to avoid charges. this will return your instance id if you associated it with your elastic ip.
INSTANCE_ID="$(aws ec2 describe-addresses --public-ips 52.2.158.11 --query 'Addresses[*][InstanceId]' --output text)"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

