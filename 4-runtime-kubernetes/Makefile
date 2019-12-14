##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite

up:
	helm install k8s-sample .

lint:
	helm lint .

status:
	helm status k8s-sample
	kubectl -n k8s-sample get all -l app=k8s-sample
	kubectl -n k8s-sample describe deployment -l app=k8s-sample

logs:
	kubectl -n k8s-sample logs -l app=k8s-sample

down:
	helm uninstall k8s-sample

package:
	helm package -d .. .

