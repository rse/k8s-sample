##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

all: build

bootstrap:
	if [ ! -d node_modules ]; then npm install; fi

build: bootstrap
	npm run build

start:
	npm start

clean:
	-rm -rf dst

distclean: clean
	-rm -rf node_modules

