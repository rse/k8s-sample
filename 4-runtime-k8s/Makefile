##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE = sqlite
BASEDIR  = ${PWD}/.k8s

up:

down:

logs:

k8s: k8s-1 k8s-2 k8s-3 k8s-4 k8s-5 k8s-6 k8s-7

#   establish client-side
k8s-1:
	rm -rf $(BASEDIR); mkdir $(BASEDIR)
	docker run -i --rm docker.msg.team/ps/std-kubernetes \
	    tarball kubectl kustomize helm helm2 helm3 | tar xf - -C $(BASEDIR)
	echo "export PATH=\\$$PATH:$(BASEDIR)" >$(BASEDIR)/env
	echo "export HELM_VERSION=3" >>$(BASEDIR)/env
	echo "source /etc/bash_completion" >>$(BASEDIR)/env
	echo "source <(kubectl completion bash)" >>$(BASEDIR)/env
	echo "source <(helm completion bash)" >>$(BASEDIR)/env

#   establish server-side
k8s-2:
	sudo docker-stack prune ase-k3s || true
	sudo docker-stack configure params ase-k3s K3S_CLUSTER_SECRET=$$(apg -n1 -a0 -m32 -x32 -MCL)
	sudo docker-stack install ase-k3s && sleep 8
	sudo docker-stack exec ase-k3s kubeconfig admin admin >~/.k8s/kubeconfig-admin.yaml

#   check connectivity under "admin"
k8s-3:
	source ~/.k8s/env; \
	export KUBECONFIG=~/.k8s/kubeconfig-admin.yaml; \
	kubectl -o yaml version; \
	kubectl -n kube-system get all

#   create cluster admin service account "root"
k8s-4:
	source ~/.k8s/env; \
	export KUBECONFIG=~/.k8s/kubeconfig-admin.yaml; \
	bash k8s-util.bash create-cluster-admin default root; \
	bash k8s-util.bash generate-kubeconfig default root root >~/.k8s/kubeconfig-root.yaml; \

#   check connectivity under "root"
k8s-5:
	source ~/.k8s/env; \
	export KUBECONFIG=~/.k8s/kubeconfig-root.yaml; \
	kubectl -o yaml version; \
	kubectl -n kube-system get all

#   deploy an application
k8s-6:
	source ~/.k8s/env; \
	export KUBECONFIG=~/.k8s/kubeconfig-root.yaml; \
	bash k8s-util.bash create-namespace sample; \
	bash k8s-util.bash create-namespace-admin sample sample; \
	bash k8s-util.bash generate-kubeconfig sample sample sample >~/.k8s/kubeconfig-sample.yaml; \
	export KUBECONFIG=~/.k8s/kubeconfig-sample.yaml; \
	bash k8s-util.bash create-deployment sample kuard "gcr.io/kuar-demo/kuard-amd64:blue" 8080; \
	kubectl get all; \
	kubectl describe deployment kuard

#   test-drive various contexts
k8s-7:
	bash k8s-util.bash generate-kubeconfig-stub >~/.k8s/kubeconfig-stub.yaml; \
	echo "export KUBECONFIG=~/.k8s/kubeconfig-stub.yaml:~/.k8s/kubeconfig-admin.yaml:~/.k8s/kubeconfig-root.yaml:~/.k8s/kubeconfig-sample.yaml" >>~/.k8s/env; \
	source ~/.k8s/env; \
	kubectl config use-context admin; \
	kubectl --context admin  -n kube-system get all; \
	kubectl --context root   -n kube-system get all; \
	kubectl --context sample -n sample get all

k8s-maesh:
	source ~/.k8s/env; \
	kubectl create namespace maesh; \
	helm repo add maesh https://containous.github.io/maesh/charts; \
	helm repo update; \
	helm install maesh --namespace=maesh --set "tracing.deploy=false,metrics.deploy=false,smi=true" maesh/maesh

