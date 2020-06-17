#!/bin/bash
WEBSERVER=`cat "$SGE_ROOT"/"$SGE_CELL"/common/act_qmaster`
elinks --source    http://"$WEBSERVER"/sgecuda/'?hname='$HOSTNAME'&sid='$JOB_ID'&setid=0&NSLOTS=0'

