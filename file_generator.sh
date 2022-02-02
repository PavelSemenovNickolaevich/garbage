#!/bin/bash

filecount=0

<<cc
This script is used to
Calculate the cube of
a number with value 5
cc


while [ $filecount -lt 10000 ]
do

filesize=$RANDOM
filesize=$(($filesize+1024))

base64 /dev/urandom | head -c "$filesize" > $(pwd)/file${filecount}.$RANDOM

((filecount++))

echo -e "Count - $filecount, File size - $filesize, File name - file${filecount}.$RANDOM"
done
