##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

build:
	cd fe && $(MAKE) $(MFLAGS) build
	cd be && $(MAKE) $(MFLAGS) build

start:
	cd fe && $(MAKE) $(MFLAGS) start
	cd be && $(MAKE) $(MFLAGS) start

clean:
	cd fe && $(MAKE) $(MFLAGS) clean
	cd be && $(MAKE) $(MFLAGS) clean

distclean:
	cd fe && $(MAKE) $(MFLAGS) distclean
	cd be && $(MAKE) $(MFLAGS) distclean

