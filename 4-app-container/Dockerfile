##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

#   container information
ARG         IMAGE_PREFIX=docker.io/engelschall/
ARG         IMAGE_NAME=k8s-sample
ARG         IMAGE_VERSION=0.9.2
ARG         IMAGE_RELEASE=20200106

#   start with the standard Node.js container image
FROM        node:12.14-alpine

#   update system
RUN         apk update && \
            apk upgrade && \
            apk add bash

#   provide build environment
RUN         apk add --no-cache --virtual .build-env \
                binutils-gold gcc make \
                linux-headers libgcc \
                shadow xz tar

#   create application program area
RUN         groupadd -g 2000 app
RUN         useradd -u 2000 -g app -d /app -m -s /bin/sh -p '!' -l app
RUN         mkdir -p /app/bin /app/etc /app/lib /app/tmp
ENV         HOME=/app

#   create application data rea
RUN         mkdir -p /data

#   fixate ownership
RUN         chown -R app:app /app
RUN         chown -R app:app /data

#   establish build environment
USER        app:app
WORKDIR     /app/tmp
COPY        src.tar.xz .
RUN         xz -d -c <src.tar.xz | tar xf -; rm -f src.tar.xz

#   reconfigure NPM
RUN         (   echo "spin=false"; \
                echo "save=false"; \
                echo "loglevel=error" ) >/app/.npmrc

#   build application
RUN         (   cd fe && \
                npm install && \
                NODE_ENV=production npm run build )
RUN         (   cd be && \
                NODE_ENV=production npm install )

#   install application
RUN         mkdir -p \
                /app/lib/sample/fe \
                /app/lib/sample/be
RUN         cp -rp \
                fe/dst/* \
                /app/lib/sample/fe/
RUN         cp -rp \
                be/package.json \
                be/src \
                be/node_modules \
                /app/lib/sample/be/

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
ENTRYPOINT  [   "node", "/app/lib/sample/be/src/app.js", \
                "-d", "sqlite3:/data/app.sqlite", \
                "-u", "/app/lib/sample/fe", \
                "-a", "0.0.0.0", \
                "-p", "9090" ]
CMD         []

#   expose HTTP port
EXPOSE      9090

