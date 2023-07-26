FROM node:16-bullseye

WORKDIR /usr/src/app

COPY ./content .

ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    addgroup --gid 10014 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    wget -qO - https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.4/shadowsocks-v1.15.4.x86_64-unknown-linux-gnu.tar.xz | tar xz -C . &&\
    cd shadowsocks*/ && mv * ../ &&\
    chmod +x server.sh ss*

USER 10014

ENTRYPOINT ["node", "server.js"]
