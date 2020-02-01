##
##  docker-ps.bash -- Docker CLI provisioning (for ProjectServer contexts)
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##
##  Usage:
##  | source docker-ps.bash <hostname-or-address>
##  | docker [...]
##  | docker-compose [...]
##

#   provision for standard context
source "$(dirname ${BASH_SOURCE})/docker.bash"

#   provision for ProjectServer (PS) context
docker_ps () {
    #   determine server
    if [[ $# -ne 1 ]]; then
        echo "** ERROR: missing hostname or address of ProjectServer (PS)" 1>&2
        return 1
    fi
    local server="$1"

    #   set docker(1) environment variables
    export DOCKER_TLS=1
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST="tcp://$server:2376"
    export DOCKER_CERT_PATH="$docker_etcdir"

    if [[ ! -f "$DOCKER_CERT_PATH/ca.pem" ]]; then
        echo "++ fetching CA certificate"
        scp -q root@$server:/etc/docker/ca.crt $DOCKER_CERT_PATH/ca.pem
        chmod 600 $DOCKER_CERT_PATH/ca.pem
    fi
    if [[ ! -f "$DOCKER_CERT_PATH/cert.pem" ]]; then
        echo "++ fetching client certificate"
        scp -q root@$server:/etc/docker/client.crt $DOCKER_CERT_PATH/cert.pem
        chmod 600 $DOCKER_CERT_PATH/cert.pem
    fi
    if [[ ! -f "$DOCKER_CERT_PATH/key.pem" ]]; then
        echo "++ fetching client private key"
        scp -q root@$server:/etc/docker/client.key $DOCKER_CERT_PATH/key.pem
        chmod 600 $DOCKER_CERT_PATH/key.pem
    fi
}

docker_ps ${1+"$@"}
unset docker_ps

