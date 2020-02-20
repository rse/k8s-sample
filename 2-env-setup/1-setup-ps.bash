##
##  1-setup-ps.bash -- setup environment on msg Project Server (PS) with K3S Kubernetes
##

#   parse command-line arguments
INSTALL=no
while getopts ":i" option; do
    case $option in
        i  ) INSTALL=yes ;;
        \? ) echo "Usage: source $0 [-p] [-i] <hostname>"; exit 1 ;;
    esac
done
shift $((OPTIND -1))
SERVER=${1-"10.16.19.50"}

#   check whether K3S is already installed
echo "++ server-side: checking for K3S Kubernetes installation (ase-k3s)"
ssh -q root@$SERVER 'docker-stack status ase-k3s >/dev/null 2>&1'
if [[ $rc -eq 0 ]]; then
    INSTALLED=yes
else
    INSTALLED=no
fi

#   ensure K3S is installed
if [[ $OPT_INSTALL == yes ]]; then
    if [[ $INSTALLED == yes ]]; then
        #   optionally prune K3S before installation
        echo "++ server-side: pruning old K3S Kubernetes installation (ase-k3s)"
        ssh -q root@$SERVER 'docker-stack prune ase-k3s || true'
    fi

    #   optionally install K3S
    echo "++ server-side: installing new K3S Kubernetes installation (ase-k3s)"
    ssh -q root@$SERVER 'docker-stack configure params ase-k3s \
        K3S_CLUSTER_SECRET="$(apg -n1 -a0 -m32 -x32 -MCL)" \
        K3S_PASSWD_ADMIN="$(apg -n1 -a0 -m32 -x32 -MCL)" \
        K3S_PASSWD_SYSTEM="$(apg -n1 -a0 -m32 -x32 -MCL)" && \
        docker-stack install ase-k3s'
    echo "++ server-side: give Kubernetes some time to spin up"
    sleep 15
elif [[ $INSTALLED == no ]]; then
    echo "** ERROR: require K3S (either pre-installed or requested to be installed)" 1>&2
    exit 1
fi

#   ensure we find k8s-util(1)
PATH=$(dirname ${BASH_SOURCE})/../1-env-util/k8s-util.run/bin:$PATH

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
k8s-util kubeconfig | \
    k8s-util configure-k8s default -

echo "++ client-side: fetching kubectl(1) access configuration for external cluster admin account \"admin\""
ssh -q -t root@$SERVER docker-stack exec ase-k3s kubeconfig admin admin | \
    k8s-util configure-k8s admin -

echo "++ client-side: switching kubectl(1) access configuration to external cluster admin account \"admin\""
source <(k8s-util env)
kubensx use -n kube-system
kubensx use -u admin

