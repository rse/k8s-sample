##
##  3-root.bash -- create Kubernetes internal cluster admin account
##

PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

echo "++ creating Kubernetes internal cluster admin account \"root\""
k8s-util cluster-admin kube-system root create

echo "++ fetching kubectl(1) access configuration for internal cluster admin account \"root\""
k8s-util kubeconfig kube-system root root | k8s-util configure-k8s root -
source <(k8s-util env)
kubensx use -n kube-system
kubensx use -u root

