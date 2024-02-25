#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
export SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
export SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
export SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
export SPRING_DATASOURCE_HOST=${SPRING_DATASOURCE_HOST}
export SPRING_DATASOURCE_PORT=${SPRING_DATASOURCE_PORT}
export SPRING_DATASOURCE_DATABASE=${SPRING_DATASOURCE_DATABASE}
export SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
export BACKEND_VERSION=${BACKEND_VERSION}
export BACKEND_REPORT_VERSION=${BACKEND_REPORT_VERSION}
export REPORTS_MONGODB_URI=${REPORTS_MONGODB_URI}
export FRONTEND_VERSION=${FRONTEND_VERSION}
export BLUE_SERVICE=${BLUE_SERVICE}
export GREEN_SERVICE=${GREEN_SERVICE}
docker login -u ${CI_REGISTRY_USER} -p${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
echo ${BACKEND_VERSION}
docker network create -d bridge sausage_network || true
echo ${REPORTS_MONGODB_URI}
pwd
cd /home/student/sausage-store2|| true

if docker ps --format "{{.Names}}" | grep ${BLUE_SERVICE}; then
  docker-compose pull ${GREEN_SERVICE}
  docker-compose up -d ${GREEN_SERVICE}
  docker-compose ps ${GREEN_SERVICE} | xargs -I {} echo "--wait {}:healthy" | xargs docker-compose rm -s -f ${BLUE_SERVICE}
elif docker ps --format "{{.Names}}" | grep ${GREEN_SERVICE}; then
  docker-compose pull ${BLUE_SERVICE}
  docker-compose up -d ${BLUE_SERVICE}
  docker-compose ps ${BLUE_SERVICE} | xargs -I {} echo "--wait {}:healthy" | xargs docker-compose rm -s -f ${GREEN_SERVICE}
else
  docker-compose pull ${BLUE_SERVICE}
  docker-compose up -d ${BLUE_SERVICE}
fi

# docker-compose rm -s -f backend || true
# docker-compose up -d backend
#docker-compose up -d sausage-backend

#будеме переделывать эту часть
# sudo docker run -d --name sausage-backend --env SPRING_DATASOURCE_URL="${SPRING_DATASOURCE_URL}" \
#      --env SPRING_DATASOURCE_USERNAME="${SPRING_DATASOURCE_USERNAME}" \
#      --env SPRING_DATASOURCE_PASSWORD="${SPRING_DATASOURCE_PASSWORD}" \
#      --env SPRING_DATA_MONGODB_URI="${SPRING_DATA_MONGODB_URI}" \
#      --network=sausage_network \
#      --restart=always \
#      "${CI_REGISTRY_IMAGE}"/sausage-backend:latest 

#пока что убрал rm, чтоб мониторить работу контейнера
# Старый код
#Перезаливаем дескриптор сервиса на ВМ для деплоя
# sudo cp -rf backend.service /etc/systemd/system/backend.service #тут мы перекидывай из /home/student файлик backend.service в /etc/systemd/system
# sudo rm -f /opt/sausage-store/bin/sausage-store*.jar||true #далее удаляем старый джарник
# #Переносим артефакт в нужную папку
# curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/${NEXUS_REPO_BACKEND_NAME}/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
# #здесь мы скачаваем джарник sausage-store-${VERSION}.jar с нексуса и сохраняем его по имени sausage-store.jar. Для скачивания используем креды, которые
# #зашили в переменные в гитлабе ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS}
# sudo cp ./sausage-store.jar /opt/sausage-store/bin/sausage-store.jar||true #"<...>||true" говорит, если команда обвалится — продолжай, перекидываем 
# # файлик в  директорию, где изначально хранился наш джарник
# #Обновляем конфиг systemd с помощью рестарта
# sudo systemctl daemon-reload
# #Перезапускаем сервис сосисочной
# sudo systemctl restart backend 
