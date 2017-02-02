#!/bin/bash
# Calculator using bc

MAX_ARGNUM=1

if [ $# -ne $MAX_ARGNUM ]
	then
	echo "Only one argument allow!"
	exit 85
fi

ret=$(echo "scale=16; $1" | bc -l)

echo $ret