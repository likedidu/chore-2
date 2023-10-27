FROM alpine

WORKDIR /tmp

COPY ./config /app/

ENV PORT=3000
ENV SecretPATH=/mypath
ENV PASSWORD=password
ENV WG_MTU=1408
ENV BLOCK_QUIC_443=true
ENV CLASH_MODE=rule

RUN apk add --no-cache caddy jq \
    && sh /app/install.sh \
    && rm /app/install.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo
   
USER 10001

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
