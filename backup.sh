#!/bin/bash
 
otkuda="/app/"
kuda="/mnt/backup"
 
# Указываем какие папки хотим забекапить, если нужна не одна. 
which_dir="dir1 dir2 dir3 dir4 dir5"
 
# Создаем папку с датой в названии под наш бекап
 
mkdir -p $kuda/$(date +"%Y-%m-%d")
backup_dir="$kuda/$(date +"%Y-%m-%d")"
 
# Начинаем цикл for, где для каждого значения переменной (списка в ней) делаем (do) набор действий 
for dir in $which_dir; do
 
echo "Копируем $otkuda$dir в $backup_dir"
 
# Копируем указанные папки рекурсивно (-a), с выводом процесса (-v) и удобочитаемыми размерами (-h)
rsync -avh  $otkuda$dir $backup_dir
 
done
 
# Архивируем всю папку, в которой лежит бекап со сжатием gzip (-z)
# c – создает новый файл .tar;
# v – выводит подробное описание процесса сжатия;
# f – имя файла.
# z - сжатие gzip, чтобы уменьшить размер архива. 
tar -cvzf /root/Yandex.Disk/backup_$(date +"%Y-%m-%d").tar.gz $backup_dir
 
# Удаляем файлы, которые сохранили в архив чтобы они не занимали место. 
rm -rf $backup_dir
 
# Перезапуск, на всякий случай, чтобы бекап точно выгрузился. 
yandex-disk stop
yandex-disk start
