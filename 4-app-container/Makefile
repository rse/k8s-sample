##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

include Makefile.inc

DOCKER_BUILD_SOURCE = ../3-app-source
DOCKER_RUN_FLAGS    += -p 9090:9090
DOCKER_RUN_ARGS     += -d sqlite3:/data/app.sqlite -a 0.0.0.0 -p 9090

