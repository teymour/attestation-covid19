FROM debian:9-slim

VOLUME ["/data"]

COPY entrypoint.sh /

ENV TZ=Europe/Paris

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && chmod +x /entrypoint.sh

RUN apt-get update --quiet --quiet \
    && apt-get install --yes \
        inkscape \
        gettext-base \
        python-qrcode \
        pdftk \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
