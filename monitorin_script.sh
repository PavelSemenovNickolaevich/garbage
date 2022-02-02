# для мониторинга веб сервиса (nginx php)

#/bin/bash

# Возвращение вывода к стандартному форматированию
NORMAL='\033[0m'      # ${NORMAL}

# Цветом текста (жирным) (bold) :
WHITE='\033[1;37m'    # ${WHITE}

# Цвет фона
BGRED='\033[41m'      # ${BGRED}
BGGREEN='\033[42m'    # ${BGGREEN}
BGBLUE='\033[44m'     # ${BGBLUE}


# Получаем статус веб-сервера через systemd  записываем его в переменную.
nginxstatus=$(systemctl status nginx | grep -Eo "running|dead|failed")

            if [[ $nginxstatus = 'running' ]]
                then
                    echo -en  "${WHITE} ${BGGREEN} Веб сервер работает ${NORMAL}\n"
                else
                    echo -en "${WHITE} ${BGRED} nginx не работает ${NORMAL}\n"
                    systemctl restart nginx # Перезапуск nginx
                    sleep 1 #  Ожидаем 1 секунду, чтобы сервер точно запустился.

                    echo -en "${WHITE} ${BGGREEN} Статус Nginx после перезапуска $(systemctl status nginx | grep -Eo "running|dead|failed") ${NORMAL}\n"
                    echo $(curl -I 78.24.221.127 | grep OK) # Проверяем отдает ли веб-сервер http код 200
            fi

# Получаем статус php через systemd  записываем его в переменную.
phpfpmstatus=`systemctl status php7.2-fpm | grep -Eo "running|dead|failed"`

            if [[ $phpfpmstatus = 'running' ]]
                then
                    echo -en  "${WHITE} ${BGGREEN} php7.2-fpm работает ${NORMAL}\n"
                else
                    echo -en "${WHITE} ${BGRED} Статус php7.2-fpm $phpfpmstatus Пробуем перезапустить. ${NORMAL}\n"
                    systemctl restart php7.2-fpm # Перезапуск php7.2-fpm
                    sleep 1 #  Ожидаем 1 секунду, чтобы php7.2-fpm точно запустился.

                    echo -en "${WHITE} Статус php7.2-fpm после перезапуска $(systemctl status php7.2-fpm | grep -Eo "running|dead|failed") ${NORMAL}\n"
            fi
