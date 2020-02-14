##
##  1-setup-std.bash -- setup environment for standard Kubernetes contexts
##

PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

kubeconfig="$1"
dockerurl="$2"

echo "++ client-side: pruning client-side environment"
k8s-util cleanup

echo "++ client-side: setup Docker & Kubernetes client-side environment"
k8s-util setup

echo "++ client-side: configure Docker URL"
if [[ -n $dockerurl ]]; then
    k8s-util configure-docker url "$dockerurl"
fi

echo "++ client-side: creating kubectl(1) access configuration stub"
k8s-util kubeconfig | k8s-util configure-k8s default -

echo "++ client-side: fetching kubectl(1) access configuration for external cluster admin account"
if [[ -n $kubeconfig ]]; then
    k8s-util configure-k8s admin "$kubeconfig"
fi
source <(k8s-util env)
kubensx use -n kube-system
kubensx use -u admin

