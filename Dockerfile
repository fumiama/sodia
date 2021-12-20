FROM alpine:latest

RUN apk update && apk add --no-cache py3-lxml python3
RUN apk add --no-cache openssl libsodium-dev && apk add --no-cache --virtual .build-deps git
RUN git clone --depth=1 https://github.com/shadowsocksrr/shadowsocksr.git /usr/local/ssr
RUN apk del .build-deps && rm -rf /usr/local/ssr/.git

WORKDIR /data

RUN echo '{\
"server":"0.0.0.0",\
"server_ipv6":"::",\
"server_port":9000,\
"local_address":"127.0.0.1",\
"local_port":1080,\
"password":"password0",\
"timeout":120,\
"method":"aes-256-cfb",\
"protocol":"origin",\
"protocol_param":"",\
"obfs":"plain",\
"obfs_param":"",\
"redirect":"",\
"dns_ipv6":false,\
"fast_open":true,\
"workers":1\
}' > /data/ssr.json

ENTRYPOINT [ "python3", "/usr/local/ssr/shadowsocks/server.py", "-c", "/data/ssr.json" ]