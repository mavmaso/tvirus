FROM hexpm/elixir:1.11.4-erlang-23.3.4.4-alpine-3.13.3

RUN apk update \
    && apk add --no-cache tzdata build-base \
    && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone \
    && apk del tzdata

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.13/main" >> /etc/apk/repositories \
    && apk update --update-cache \
    && apk add --no-cache \
    curl \
    git \
    wget \
    libstdc++ \
    harfbuzz \
    nss \
    freetype \
    ttf-freefont \
    font-noto-emoji \
    wqy-zenhei

WORKDIR /app
COPY . ./

RUN mix do local.hex --force, local.rebar --force
RUN mix do deps.get
RUN mix compile