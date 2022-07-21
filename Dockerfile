
############################################################
# Dockerfile to run Easy!Appointments
# Based on Alpine
############################################################

FROM alpine:3.15.4

MAINTAINER elKaribu (elkaribu)

ENV BASE_URL=http://207.180.214.153:8888
ENV LANGUAGE=english
ENV CSRF_PROTECTION=TRUE
ENV DEBUG=FALSE
ENV EMAIL_IGNORE_SSL=FALSE
ENV DB_HOST=db
ENV DB_NAME=easyappointments
ENV DB_USERNAME=root
ENV DB_PASSWORD=root
ENV GOOGLE_SYNC_FEATURE=FALSE
ENV GOOGLE_PRODUCT_NAME=""
ENV GOOGLE_CLIENT_ID=""
ENV GOOGLE_CLIENT_SECRET=""
ENV GOOGLE_API_KEY=""
ENV EMAIL_HOST=""
ENV EMAIL_USER=""
ENV EMAIL_PASSWORD=""
ENV EMAIL_CRYPTO=""
ENV EMAIL_PORT=587
ENV TZ="America/Port_of_Spain"
ENV EASYAPPOINTMENTS_VERSION="1.4.3"

EXPOSE 8888

WORKDIR /app/

RUN apk add --no-cache tini \
    nginx \
    ca-certificates \
    php8-fpm \
    php8-json \
    php8-zlib \
    php8-xml \
    php8-pdo \
    php8-phar \
    php8-openssl \
    php8-pdo_mysql \
    php8-mysqli \
    php8-gd \
    php8-iconv \
    php8-ctype \
    php8-curl \
    php8-session \
    php8-mbstring \
    python3 \
    tzdata \
    bash

COPY ./app/nginx.conf /app/nginx.conf
COPY ./app/php-fpm.conf /app/php-fpm.conf

RUN mv /app/nginx.conf /etc/nginx/nginx.conf && \
    mkdir -p /etc/php/ && \
    mv /app/php-fpm.conf /etc/php/php-fpm.conf && \
    mkdir -p /tmp/nginx

WORKDIR /app/www/

ADD https://github.com/alextselegidis/easyappointments/releases/download/${EASYAPPOINTMENTS_VERSION}/easyappointments-${EASYAPPOINTMENTS_VERSION}.zip /app/www/

RUN unzip -o /app/www/easyappointments-${EASYAPPOINTMENTS_VERSION}.zip && \
    rm easyappointments-${EASYAPPOINTMENTS_VERSION}.zip

COPY ./app/ /app/

ENTRYPOINT ["/sbin/tini", "--", "python3", "/app/run.py"]
