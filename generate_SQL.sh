#!/bin/bash
unset FQDN

#For example ,all of you exec host is xxx.msn.com , please fill FQDN line to FQDN='.msn.com'
FQDN='.hn.org'
if [ -z $FQDN ]; then
    echo "Please fill the FQDN= line on this script !"
    exit 1
fi 

LIST=''

echo "CREATE TABLE cuda_list ( id int(11) NOT NULL AUTO_INCREMENT, hostname varchar(64) NOT NULL, device_id tinyint(3) unsigned NOT NULL, isInuse BOOLEAN NOT NULL DEFAULT false, sge_job_id int(10) unsigned DEFAULT 0,isManually BOOLEAN NOT NULL DEFAULT FALSE, PRIMARY KEY (id)); " 

for i in `qhost |sed '1,3d'  |awk '{print $1}'`
do
  LIST=`qconf -se $i |grep -q ngpus && echo $i `" "$LIST
done
for i in $LIST
do
	GPU_NUM=`qconf -se $i |grep  ngpus|awk -F '=' '{print $2}'`
	FULL_HOSTNAME=$i$FQDN
	let GPU_NUM-=1
		for j in `seq 0 $GPU_NUM `
		do
			echo INSERT INTO cuda_list \(hostname ,device_id\) VALUES \(\'$FULL_HOSTNAME\',"$j"\)\; 
		done	
done

