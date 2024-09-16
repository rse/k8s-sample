##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

#   container information
ARG         IMAGE_PREFIX=docker.io/engelschall/
ARG         IMAGE_NAME=k8s-sample
ARG         IMAGE_VERSION=0.9.5
ARG         IMAGE_RELEASE=20200612

#   ==== STAGE 1 ====

#   derive image from a certain base image
FROM        golang:1.23.1-alpine3.19 AS stage1

#   add additional build tools
RUN         apk update && apk upgrade && apk add git binutils

#   create build environment
ENV         GOPATH=/tmp/build
WORKDIR     /tmp/build

#   build Dockerize
RUN         git clone https://github.com/jwilder/dockerize \
                $GOPATH/src/github.com/jwilder/dockerize
WORKDIR     /tmp/build/src/github.com/jwilder/dockerize
ENV         GO111MODULE=on
RUN         go mod tidy
RUN         go build -v -o dockerize -ldflags="-extldflags=-static" .
RUN         strip dockerize

#   ==== STAGE 2 ====

#   start with the standard Node.js container image
FROM        node:12.18-alpine AS stage2

#   update system
RUN         apk update && apk upgrade && apk add bash

#   provide build environment
RUN         apk add --no-cache --virtual .build-env \
                binutils-gold gcc g++ python make shadow xz tar \
                libc-dev linux-headers libgcc libstdc++

#   create application program area
RUN         groupadd -g 10000 app
RUN         useradd -u 10000 -g app -d /app -m -s /bin/sh -p '!' -l app
RUN         mkdir -p /app/tmp
ENV         HOME=/app
RUN         chown -R app:app /app

#   establish build environment
USER        app:app
WORKDIR     /app/tmp
COPY        src.tar.xz .
RUN         xz -d -c <src.tar.xz | tar xf -; rm -f src.tar.xz

#   reconfigure NPM
RUN         (echo "spin=false"; echo "save=false"; echo "loglevel=error") >/app/.npmrc

#   build application
RUN         (cd fe && npm install --silent && NODE_ENV=production npm run build)
RUN         (cd be && npm install --silent --production)

#   ==== STAGE 3 ====

#   start with the standard Node.js container image
FROM        node:12.18-alpine

#   update system
RUN         apk update && apk upgrade && apk add bash

#   provide build environment
RUN         apk add --no-cache --virtual .build-env shadow

#   create application program area
RUN         groupadd -g 10000 app
RUN         useradd -u 10000 -g app -d /app -m -s /bin/sh -p '!' -l app
RUN         mkdir -p /app/bin /app/etc /app/lib
ENV         HOME=/app
ENV         PATH=/app/bin:$PATH

#   create application data rea
RUN         mkdir -p /data

#   fixate ownership
RUN         chown -R app:app /app
RUN         chown -R app:app /data
USER        app:app

#   install helper utility
COPY        --chown=app:app --from=stage1 /tmp/build/src/github.com/jwilder/dockerize/dockerize /app/bin/

#   install application
RUN         mkdir -p /app/lib/k8s-sample/fe /app/lib/k8s-sample/be/src /app/lib/k8s-sample/be/node_modules
COPY        --chown=app:app --from=stage2 /app/tmp/fe/dst/           /app/lib/k8s-sample/fe/
COPY        --chown=app:app --from=stage2 /app/tmp/be/package.json   /app/lib/k8s-sample/be/
COPY        --chown=app:app --from=stage2 /app/tmp/be/src/           /app/lib/k8s-sample/be/src/
COPY        --chown=app:app --from=stage2 /app/tmp/be/node_modules/  /app/lib/k8s-sample/be/node_modules/

#   install run-command script
COPY        --chown=app:app rc.sh /app/etc/rc
RUN         chmod 755 /app/etc/rc

#   remove build environment
USER        root
RUN         apk del .build-env

#   cleanup system
RUN         rm -rf /app/.npm
RUN         rm -rf /app/.config
RUN         rm -rf /app/tmp/*
RUN         rm -rf /var/cache/apk/*

#   provide volume
VOLUME      [ "/data" ]

#   finally switch to target environment
WORKDIR     /app
USER        app:app

#   provide entrypoint and start arguments
ENTRYPOINT  [ "/app/etc/rc" ]
CMD         []

#   expose HTTP port
EXPOSE      9090

