##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite

up:
	bash k8s-util.bash create-namespace k8s-sample; \
	bash k8s-util.bash create-namespace-admin k8s-sample k8s-sample; \
	bash k8s-util.bash generate-kubeconfig k8s-sample k8s-sample k8s-sample >.kubeconfig.yaml; \
	export KUBECONFIG=./.kubeconfig.yaml; \
	bash k8s-util.bash create-deployment k8s-sample k8s-sample \
        "docker.pkg.github.com/rse/k8s-sample/k8s-sample:0.9.0-20190930" 9090; \
	kubectl get all; \
	kubectl describe deployment k8s-sample

down:

logs:

