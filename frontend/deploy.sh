#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем 
sudo cp -rf sausage-store.conf /etc/nginx/sites-enabled/sausage-store.conf #тут мы перекидывай из /home/student файлик sausage-store.conf в /etc/nginx/sites-enabled
sudo rm -Rf /var/www-data/dist/frontend/*||true #далее удаляем старые файлы
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_URL}/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
#здесь мы скачаваем архив sausage-store-${VERSION}.tar.gz с нексуса и сохраняем его по имени sausage-store.tar.gz. Для скачивания используем креды, которые
#зашили в переменные в гитлабе ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS}
sudo tar -xvzf sausage-store.tar.gz --strip-components 1 -C /var/www-data/dist/frontend/||true #"<...>||true" говорит, если команда обвалится — продолжай, перекидываем 
# распаковываем архив в  директорию, где изначально хранились файлы фронтенда
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#автозапуск включаем
sudo systemctl enable nginx
#Перезапускаем сервис сосисочной
sudo systemctl restart nginx