
#Написать скрипт, который создает не пустые файлы на одной машине и передает их на другую машину.
#Скрипт запускается по CRON на первой машине. Также скрипт управляет временем хранения файлов на второй машине
#которое не должно превышать одной недели.


#!/bin/bash

from="/learnDevops/"
to="root@87.239.110.59:/learnDevops"

for i in {1..5}
do
echo "Home work $i" > file"$i".txt
rsync -avz --exclude 'script.sh' $from $to
done
ssh root@87.239.110.59 'find /learnDevops/ -name "*.txt" -atime +1  -delete '
