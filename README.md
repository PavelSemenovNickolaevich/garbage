# garbage

alias для бекапа текущей папки в конкретное место : alias bckp='echo "Как назовем бекап?" && read dir && sudo rsync -av $(pwd)/ /root/backup_$dir/ && echo "Бекап папки $(pwd) сохранен в /root/backup_$dir/" && ls -l /root/ | grep $dir'
