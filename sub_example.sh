#!/bin/bash
#$ -l ngpus=2
#$ -pe make 2
#$ -cwd
#$ -e /dev/null 
source /usr/bin/startcuda.sh 

echo \$CUDA_VISIBLE_DEVICES is:  $CUDA_VISIBLE_DEVICES
echo \$NSLOTS is: $NSLOTS
echo Your Program and parameter should be here
sleep 300

source /usr/bin/end_cuda.sh

