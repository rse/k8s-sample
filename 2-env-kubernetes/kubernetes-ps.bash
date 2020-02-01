##
##  kubernetes-ps.bash -- Kubernetes CLI provisioning (for ProjectServer contexts)
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##
##  Usage:
##  | source kubernetes-ps.bash <hostname-or-address> [<k3s-admin-password>]
##  | kubectl [...]
##  | helm [...]
##

#   provision for standard context
source "$(dirname ${BASH_SOURCE})/kubernetes.bash"

#   provision for ProjectServer (PS) context
kubernetes_ps () {
    #   determine server
    if [[ $# -ne 1 && $# -ne 2 ]]; then
        echo "** ERROR: missing hostname or address of ProjectServer (PS)" 1>&2
        return 1
    fi
    local server="$1"
    local password="${2-admin}"

    #   set kubectl(1) environment variables
    local kubernetes_basedir="$(cd $(dirname ${BASH_SOURCE}) && pwd)/kubernetes.d"

    #   expose Kubernetes access configuration
    export KUBECONFIG="$kubernetes_etcdir/kubeconfig.yaml"

    #   optionally fetch Kubernetes access configuration
    if [[ ! -f "$KUBECONFIG" ]]; then
        echo "++ fetching kubectl(1) access configuration"
        ssh -q -t root@$server "docker-stack exec ase-k3s kubeconfig admin ${password}" >"$KUBECONFIG"
    fi
}

kubernetes_ps ${1+"$@"}
unset kubernetes_ps

