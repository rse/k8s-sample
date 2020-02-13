##
##  4-namespace.bash -- create k8s-sample namespace
##

PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

echo "++ creating Kubernetes k8s-sample namespace"
k8s-util namespace k8s-sample create
k8s-util namespace-admin k8s-sample k8s-sample create

echo "++ fetching kubectl(1) access configuration for namespace service account \"sample\""
k8s-util kubeconfig k8s-sample k8s-sample k8s-sample | k8s-util configure-k8s k8s-sample -
source <(k8s-util env)

