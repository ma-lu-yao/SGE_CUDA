#!/bin/bash
WEBSERVER=`cat "$SGE_ROOT"/"$SGE_CELL"/common/act_qmaster`
sleep 35
#TMPSTR=`elinks --source  http://"$WEBSERVER"/sgecuda/'?hname='$HOSTNAME'&sid='$JOB_ID'&setid=1'`
export `elinks --source  http://"$WEBSERVER"/sgecuda/'?hname='$HOSTNAME'&sid='$JOB_ID'&setid=1&NSLOTS='$NSLOTS `
#export $TMPSTR


