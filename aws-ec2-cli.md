####THIS DOCUMENT PROVIDES SOME AWS EC2 CLI COMMANDS. IT IS NOT COMPREHENSIVE.IT ASSUMES YOU INSTALLED AWS CLI TOOLS. ALL THE COMMANDS ARE RUN FROM A LINUX TERMNAL.####

__get info about all your instances__     
```aws ec2 describe-instances```

__launch your instance__   
__YOU WILL NEED: your ami id, your key (ie ucb.pem), your security group id, and your subnet id.__   
__You can get all these when you first created your instance__   
```aws ec2 run-instances --image-id ami-1785fe72 --key ucb --instance-type m3.large --security-group-ids sg-a5e90ec3 --subnet subnet-bcf5bd97```

__associate elastic ip (make sure to get the right id from above command output)__      
```aws ec2 associate-address --instance-id i-xxxxx --public-ip 52.2.158.11```

__attach your volume (may need to detach automatically attached volume)__      
```aws ec2 describe-volumes```

__detach the one that is /dev/sdf__      
```aws ec2 detach-volume --volume-id vol-xxxxxxx```

__(make sure to get the right id from above describe-instances command output)__      
*the volume id is your EBS volume id*      
```aws ec2 attach-volume --volume-id vol-xxxxxx --instance-id i-xxxxxx --device /dev/sdf```

______________

```ssh -i "ucb.pem" root@52.2.158.11```

```mount /dev/xvdf /data```
```
# commented steps were already performed
# /usr/lib/hadoop/libexec/init-hdfs.sh
# sudo -u hdfs hdfs dfs -mkdir /user/ucb
# sudo -u hdfs hdfs dfs -chown ucb /user/ucb
```
`bash start-hadoop.sh`
(it's in here: /root/start-hadoop.sh)      

__to avoid spark path shenannigans, su <user> first__   

`su ucb`   
`hive`   

`exit;`   
`pyspark`   


__zeppelin:__   
`cd /data/zeppelin`   
`bin/zeppelin.sh`   

`http://ec2-52-2-158-11.compute-1.amazonaws.com:8080`

----------
on logout:
```
cd $HOME
bash stop-hadoop.sh
umount /data
```
__sanity check to make sure your volumen was unmounted:__   
`df -h`   
*you should __not__ see your volume anymore*   
`exit`

__detach your volume__   
`aws ec2 detach-volume --volume-id vol-xxxxx`

__terminate your instance to avoid charges. this will return your instance id if you associated it with your elastic ip.__   
```
INSTANCE_ID="$(aws ec2 describe-addresses --public-ips 52.2.158.11 --query 'Addresses[*][InstanceId]' --output text)"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```

