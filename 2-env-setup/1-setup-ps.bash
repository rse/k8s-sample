##
##  1-setup-ps.bash -- setup environment on msg Project Server (PS) with K3S Kubernetes
##

PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

SERVER=${1-"10.16.19.50"}

echo "++ server-side: pruning old K3S Kubernetes installation"
ssh root@$SERVER 'docker-stack prune ase-k3s || true'

echo "++ server-side: installing new K3S Kubernetes installation"
ssh root@$SERVER 'docker-stack configure params ase-k3s \
    K3S_CLUSTER_SECRET="$(apg -n1 -a0 -m32 -x32 -MCL)" \
    K3S_PASSWD_ADMIN="$(apg -n1 -a0 -m32 -x32 -MCL)" \
    K3S_PASSWD_SYSTEM="$(apg -n1 -a0 -m32 -x32 -MCL)" && \
    docker-stack install ase-k3s'

echo "++ server-side: give Kubernetes some time to spin up"
sleep 8

echo "++ client-side: pruning client-side environment"
k8s-util cleanup

echo "++ client-side: setup Docker & Kubernetes client-side environment"
k8s-util setup

echo "++ client-side: configure Docker URL"
k8s-util configure-docker url "tcp://$SERVER:2376"

echo "++ client-side: fetching Docker TLS access credentials"
ssh -q root@$SERVER cat /etc/docker/ca.crt     | k8s-util configure-docker ca   -
ssh -q root@$SERVER cat /etc/docker/client.crt | k8s-util configure-docker cert -
ssh -q root@$SERVER cat /etc/docker/client.key | k8s-util configure-docker key  -

echo "++ client-side: creating kubectl(1) access configuration stub"
k8s-util kubeconfig | k8s-util configure-k8s default -

echo "++ client-side: fetching kubectl(1) access configuration for external cluster admin account \"admin\""
ssh -q -t root@$SERVER docker-stack exec ase-k3s kubeconfig admin admin | k8s-util configure-k8s admin -
source <(k8s-util env)
kubensx use -n kube-system
kubensx use -u admin

