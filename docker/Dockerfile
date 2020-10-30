FROM debian:9

VOLUME ["/data"]

COPY entrypoint.sh /

ENV TZ=Europe/Paris

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && chmod +x /entrypoint.sh

RUN apt-get update \
    && apt-get install -y \
        inkscape \
        gettext-base \
        python-qrcode \
        pdftk \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
