##
##  1-setup-gsk.bash -- setup environment on GlobalScale Kubernetes in msg.Cloud
##

PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

SERVER=${1-"10.16.19.50"}

echo "++ client-side: pruning client-side environment"
k8s-util cleanup

echo "++ client-side: setup Docker & Kubernetes client-side environment"
k8s-util setup

echo "++ client-side: creating kubectl(1) access configuration stub"
k8s-util kubeconfig | k8s-util configure-k8s default -

echo "++ client-side: fetching kubectl(1) access configuration for external cluster admin account \"admin\""
k8s-util configure-k8s admin ~/k8s-sample-kubeconfig.yaml
source <(k8s-util env)
kubensx use -n kube-system
kubensx use -u admin

