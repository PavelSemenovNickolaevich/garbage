#!/bin/bash


BACKUP_LOCK=/var/lock/backup_vm.lock
BACKUP_LOG=/var/log/backup.log
USED_SPACE=95
BACKUP_DURATION=30
REMOTE_BACKUP_DIR=backup                
USER=backup
PASSWORD="123654"
REMOTE_HOST=192.168.88.33     
BACKUP_DIR=/opt/nas
DT=`date '+%Y%m%d'`
BACKUP_SRC=/opt/Share
DBHOST="localhost"
DBNAME="our_site"
DBUSER="site_user"
DBPASS="db_secure_pass"




function toLog {
    local message=$1
    echo "[`date \"+%F %T\"`] ${message}" >> $BACKUP_LOG
}

function checkUsedSpace {
        if [[ `df -h|grep //$REMOTE_HOST/$REMOTE_BACKUP_DIR|awk '{print $5}'|sed 's/%//g'` -ge $USED_SPACE ]]; then
                toLog "Used space on $REMOTE_HOST:$REMOTE_BACKUP_DIR higher then $USED_SPACE%."
                toLog "END"
                toLog ""
                rm -f $BACKUP_LOCK
                umount $BACKUP_DIR
                exit
        fi
}

function checkBackupDir {
        local backup_duration=$1
        find $BACKUP_DIR/$host/$backup_level -type f -mtime +$backup_duration -exec rm -rf {} \;
}




while [ -e $BACKUP_LOCK ]
do
    sleep 1
done

touch $BACKUP_LOCK
toLog "START"


mount -t cifs //$REMOTE_HOST/$REMOTE_BACKUP_DIR $BACKUP_DIR -o username=$USER,password=$PASSWORD,rw > /dev/null 2>&1
if [ $? -ne 0 ]; then
        if [[ `df -h|grep //$REMOTE_HOST/$REMOTE_BACKUP_DIR|awk '{print $1 $6}'` == "//$REMOTE_HOST/$REMOTE_BACKUP_DIR$BACKUP_DIR" ]]; then
                checkUsedSpace
        else
                toLog "Problems with mounting directory"
                toLog "END"
                toLog ""
                rm -f $BACKUP_LOCK
                exit
        fi
fi




mysqldump -u $DBUSER -p$DBPASS -h $DBHOST $DBNAME > /tmp/our_site.sql
tar -c $BACKUP_SRC /tmp/our_site.sql | pbzip2 -p4 -c > $BACKUP_DIR/$DT.tar.bz2


######

toLog "END"
toLog ""

rm -f $BACKUP_LOCK
umount $BACKUP_DIR
exit
