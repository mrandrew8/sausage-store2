FROM python:latest
RUN mkdir /app
ADD app.py /app
COPY requirements.txt /app
WORKDIR /app
RUN wget https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mkdir -p /app/report \
    && mkdir -p /app/logs \
    && chmod 777 /app/logs \
    && chmod 777 /app/report
ENV REPORT_PATH=/app/report
ENV LOG_PATH=/app/log
ENV PORT=8080 
ENV DB=mongodb://std-024-12:Testusr1234@rc1d-fmpc8y27lrcif391.mdb.yandexcloud.net:27018/std-024-12?tls=true&tlsCAFile=/app/CA.pem
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080