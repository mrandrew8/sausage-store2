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
docker login -u ${CI_REGISTRY_USER} -p${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker network create -d bridge sausage_network || true
cd /home/student/sausage-store2|| true
pwd
docker-compose rm -s -f frontend || true
docker-compose up -d frontend

#эту часть убираем
# sudo docker run -d --name sausage-frontend --network=sausage_network \
#      --restart=always -v "/home/student/${CI_PROJECT_DIR}/frontend/default.conf:/etc/nginx/conf.d/default.conf" -p 8080:80 \
#      "${CI_REGISTRY_IMAGE}"/sausage-frontend:latest 

