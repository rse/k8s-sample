##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##
##  Usage:
##  | export DOCKER_SERVER=<hostname-or-address>
##  | source docker.bash
##  | docker ...
##  | docker-compose ...
##

export DOCKER_HOST="tcp://${DOCKER_SERVER-127.0.0.1}:2376"
export DOCKER_TLS_VERIFY=1
export DOCKER_CONFIG="$(cd $(dirname ${BASH_SOURCE}) && pwd)/docker.d"
export DOCKER_CERT_PATH="$DOCKER_CONFIG/etc"
export PATH="$DOCKER_CONFIG/bin:$PATH"

docker_bash () {
    if [[ ! -d "$DOCKER_CONFIG" ]]; then
        echo "++ creating docker(1) configuration directory"
        mkdir -p \
            "$DOCKER_CONFIG/bin" \
            "$DOCKER_CONFIG/etc"
    fi

    if [[ "$(which docker)" == "" ]]; then
        local docker_version=19.03.5
        echo "++ fetching docker(1) CLI from https://download.docker.com"
        curl -sSkL $(printf "%s%s" \
            https://download.docker.com/linux/static/stable/x86_64/ \
            docker-${docker_version}.tgz) | \
            tar -z -x -f- --strip-components=1 -C $DOCKER_CONFIG/bin docker/docker
        chmod 755 $DOCKER_CONFIG/bin/docker
    fi

    if [[ "$(which docker-compose)" == "" ]]; then
        local compose_version=1.25.0
        echo "++ fetching docker-compose(1) CLI from https://github.com/docker/compose"
        curl -sSkL $(printf "%s%s" \
            https://github.com/docker/compose/releases/download/${compose_version}/ \
            docker-compose-Linux-x86_64) -o $DOCKER_CONFIG/bin/docker-compose
        chmod 755 $DOCKER_CONFIG/bin/docker-compose
    fi

    if [[ ! -f "$DOCKER_CONFIG/etc/cert.pem" ]]; then
        local host=$(echo "$DOCKER_HOST" | sed -e 's;^tcp://;;' -e 's;:.*$;;')
        echo "++ fetching docker(1) access credentials from root@$host:/etc/docker/"
        scp root@$host:/etc/docker/ca.crt     $DOCKER_CONFIG/etc/ca.pem
        scp root@$host:/etc/docker/client.crt $DOCKER_CONFIG/etc/cert.pem
        scp root@$host:/etc/docker/client.key $DOCKER_CONFIG/etc/key.pem
    fi
}

docker_bash
unset docker_bash

