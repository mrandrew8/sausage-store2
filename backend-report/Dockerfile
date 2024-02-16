FROM python:latest
RUN mkdir /app
ADD app.py /app
COPY requirements.txt /app
WORKDIR /app
RUN wget https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mkdir -p /app/report \
    && mkdir -p /app/logs \
    && Chmod 777 /app/logs \
    && Chmod 777 /app/report
ENV REPORT_PATH=/app/report
ENV LOG_PATH=/app/log
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080