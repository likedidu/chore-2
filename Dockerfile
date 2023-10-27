FROM alpine

WORKDIR /tmp

COPY ./config /app/

RUN apk add --no-cache caddy jq \
    && sh /app/install.sh \
    && rm /app/install.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo
   
USER 10001

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
