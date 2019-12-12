##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite
K8S_UTIL = bash k8s-util.bash

up:
	$(K8S_UTIL) create-namespace k8s-sample; \
	$(K8S_UTIL) create-namespace-admin k8s-sample k8s-sample; \
	$(K8S_UTIL) generate-kubeconfig k8s-sample k8s-sample k8s-sample >.kubeconfig.yaml
	KUBECONFIG=.kubeconfig.yaml $(K8S_UTIL) create-deployment \
	    k8s-sample k8s-sample "docker.io/engelschall/k8s-sample:0.9.0-20191212" 9090

down:
	KUBECONFIG=.kubeconfig.yaml $(K8S_UTIL) delete-deployment \
	    k8s-sample k8s-sample "docker.io/engelschall/k8s-sample:0.9.0-20191212" 9090
	$(K8S_UTIL) delete-namespace-admin k8s-sample k8s-sample; \
	$(K8S_UTIL) delete-namespace k8s-sample

logs:
	KUBECONFIG=.kubeconfig.yaml kubectl -n k8s-sample logs -l app=k8s-sample --all-containers=true; \
	KUBECONFIG=.kubeconfig.yaml kubectl -n k8s-sample logs -l app=k8s-sample --all-containers=true -f

status:
	KUBECONFIG=.kubeconfig.yaml kubectl get all
	KUBECONFIG=.kubeconfig.yaml kubectl describe deployment k8s-sample

