##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite
K8S_UTIL = bash k8s-util.bash

up: a b c

a:
	$(K8S_UTIL) create-namespace k8s-sample; \
	$(K8S_UTIL) create-namespace-admin k8s-sample k8s-sample; \
	$(K8S_UTIL) generate-kubeconfig k8s-sample k8s-sample k8s-sample >.kubeconfig.yaml
b:
	KUBECONFIG=.kubeconfig.yaml $(K8S_UTIL) create-deployment \
	    k8s-sample k8s-sample "docker.pkg.github.com/rse/k8s-sample/k8s-sample:0.9.0-20190930" 9090
c:
	KUBECONFIG=.kubeconfig.yaml kubectl get all
	KUBECONFIG=.kubeconfig.yaml kubectl describe deployment k8s-sample

down:

logs:

