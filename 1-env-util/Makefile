##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

all: install

install:
	@echo "++ downloading k8s-util"; \
	rm -rf k8s-util.src && \
	curl -sSkL https://github.com/rse/k8s-util/archive/master.tar.gz | gzip -d -c | tar -x -f- && \
	mv k8s-util-master k8s-util.src
	@echo "++ installing k8s-util"; \
	(cd k8s-util.src && make install PREFIX="`cd .. && pwd`/k8s-util.run")

clean:
	-rm -rf k8s-util.src
	-rm -rf k8s-util.run

