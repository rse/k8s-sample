##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

APP_CONTAINER_REPLICAS = 1
APP_STORAGE_SHARED     = false

DB_ENABLED             = false
DB_CONTAINER_REPLICAS  = 1
DB_STORAGE_SHARED      = false

switch:
	kubensx use k8s-sample:/k8s-sample

#
#  INSTALLATION
#

install:
	helm install -n k8s-sample \
	    --set app.container.replicas=$(APP_CONTAINER_REPLICAS) \
	    --set app.storage.shared=$(APP_STORAGE_SHARED) \
	    --set db.enabled=$(DB_ENABLED) \
	    --set db.container.replicas=$(DB_CONTAINER_REPLICAS) \
	    --set db.storage.shared=$(DB_STORAGE_SHARED) \
	    k8s-sample .
	@echo -n "(waiting for new K8S state to be settled... "; \
	    while [ ".`kubectl -n k8s-sample get -o 'jsonpath={ .status.readyReplicas }' \
		statefulset k8s-sample-app`" != ".$(APP_CONTAINER_REPLICAS)" ]; do sleep 0.25; done; \
	    echo "done)"

#
#  STATUS
#

status:
	helm -n k8s-sample status k8s-sample
	kubectl -n k8s-sample get all -l pkg=k8s-sample

dump:
	k8s-util dump k8s-sample

logs:
	kubectl -n k8s-sample logs -l pkg=k8s-sample

#
#  UNINSTALLATION
#

uninstall:
	helm -n k8s-sample uninstall k8s-sample
	@echo -n "(waiting for new K8S state to be settled... "; \
	    kubectl -n k8s-sample wait --timeout=90s --for=delete statefulset/k8s-sample-app >/dev/null 2>&1; \
	    echo "done)"

#
#  PACKAGING
#

package:
	helm package .

