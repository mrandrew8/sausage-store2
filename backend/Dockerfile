FROM maven:3.9.3-eclipse-temurin-20-alpine as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN wget -O  YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mvn package -Dversion.application=${VERSION} -Dmaven.test.skip=true

# шаг релиза
#FROM bellsoft/liberica-runtime-container:jre-17-slim-musl
FROM eclipse-temurin:17.0.4.1_1-jre-alpine
ARG VERSION=${VERSION}
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .
RUN keytool -importcert -file YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt \
    && cp YandexInternalRootCA.crt root.crt \
#    && rm -rf YandexInternalRootCA.crt \
    && addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && mkdir -p /home/jaruser/.postgresql \
    && mkdir -p /app/report \
    && mkdir -p /app/logs \
    && chmod 777 /app/logs \
    && chmod 777 /app/report \
    && chown -R jaruser:jaruser /home/jaruser /app/report /app/logs
ENV REPORT_PATH=/app/report
ENV LOG_PATH=/app/log
COPY --chown=jaruser:jaruser \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
COPY --chown=jaruser:jaruser \
     --from=builder /usr/src/app/YandexInternalRootCA.crt /home/jaruser/.postgresql/root.crt
RUN chmod 776 /home/jaruser/.postgresql/root.crt
EXPOSE 8080
USER jaruser
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store.jar"] 