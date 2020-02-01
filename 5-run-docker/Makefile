##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite
DETACH   = yes

install:
	docker-compose -f Composefile.$(DATABASE) up `echo $(DETACH) | sed -e 's;^yes$$;-d;' -e 's;^no$$;;'`

status:
	docker-compose -f Composefile.$(DATABASE) ps

logs:
	docker-compose -f Composefile.$(DATABASE) logs -f

uninstall:
	docker-compose -f Composefile.$(DATABASE) down

