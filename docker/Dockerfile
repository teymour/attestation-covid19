FROM debian:9-slim

VOLUME ["/data"]

COPY entrypoint.sh /

ENV TZ=Europe/Paris

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && chmod +x /entrypoint.sh

RUN apt-get update --quiet --quiet \
    && apt-get install --yes --no-install-recommends \
        gettext-base \
        inkscape \
        make \
        pdftk \
        python-qrcode \
        python-scour \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
