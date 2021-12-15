FROM quay.io/pypa/musllinux_1_1_x86_64

RUN sed -i s/3.12/3.15/ /etc/apk/repositories

RUN wget -P /etc/apk/keys/ https://jouve.github.io/jouve.rsa.pub

RUN echo https://jouve.github.io/alpine/v3.15/main >> /etc/apk/repositories

RUN apk add --no-cache libmodsecurity-dev
