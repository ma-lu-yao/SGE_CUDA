#!/bin/bash

if [ -x /opt/sge/bin/lx-amd64/qstat ]
then
	QSTAT_CMD=/opt/sge/bin/lx-amd64/qstat
	break;
elif [ -x  /usr/bin/qstat-ge ]
then
	QSTAT_CMD=/usr/bin/qstat 
	break;
elif [ -x /usr/share/gridengine/bin/linux-x64/qstat ]
then
	QSTAT_CMD=/usr/share/gridengine/bin/linux-x64/qstat
	break;
fi
#echo QSTAT_CMD is $QSTAT_CMD
echo $$ > /run/sgecuda/sgecuda.pid
MYSQLCMD="mysql -u sgecuda sgecuda "
while [ 3 >  2 ]
do
        ALLJOB=`$QSTAT_CMD  -u \* -s r |egrep -v '(^-|^job-ID)'|awk '{print $1","}' |xargs`
        ALLJOB=0,"$ALLJOB"
        ALLJOB=`echo $ALLJOB|sed "s/,$//g" `
        echo update cuda_list set isInuse=false,sge_job_id=0  where \( \( sge_job_id not in \( $ALLJOB \) \)  and isInuse=true and isManually=false \) \; | $MYSQLCMD
#        echo update cuda_list set isInuse=false,sge_job_id=0  where \( \( sge_job_id not in \( $ALLJOB \) \)  and isInuse=true and isManually=false \) \; \| $MYSQLCMD
#        echo sleeping 14 Seconds ....
        sleep  14
done
