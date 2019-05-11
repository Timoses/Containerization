FROM python:3.6-alpine

RUN apk add --no-cache --virtual .build-deps g++ linux-headers make \
    && apk add --no-cache libxml2-dev libxslt-dev \
    && pip3 install hovercraft \
    && apk del .build-deps \
    && mkdir /presentation -p \
    && apk add --no-cache --virtual .dot graphviz


COPY graphics/ /graphics
RUN cd /graphics \
    && ./build.sh png \
    && ./build.sh svg \
    && apk del .dot

WORKDIR /presentation

EXPOSE 9000

ENTRYPOINT ["hovercraft", "--port", "0.0.0.0:9000", "-N"]
