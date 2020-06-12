#!/bin/bash
##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

exec dockerize \
    $K8S_SAMPLE_OPTS_DOCKERIZE \
    node \
        $K8S_SAMPLE_OPTS_NODE \
        /app/lib/k8s-sample/be/src/app.js \
        -d sqlite3:/data/app.sqlite \
        -u /app/lib/k8s-sample/fe \
        -a 0.0.0.0 \
        -p 9090 \
        $K8S_SAMPLE_OPTS_APP \
        ${1+"$@"}

