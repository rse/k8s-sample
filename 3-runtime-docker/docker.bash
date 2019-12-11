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

DOCKER_HOST=tcp://${DOCKER_SERVER-127.0.0.1}:2376
export DOCKER_HOST

DOCKER_TLS_VERIFY=1
export DOCKER_TLS_VERIFY

DOCKER_LOCAL="$(cd $(dirname ${BASH_SOURCE}) && pwd)/docker.d"
export DOCKER_LOCAL
mkdir -p $DOCKER_LOCAL/bin $DOCKER_LOCAL/etc

DOCKER_CERT_PATH=$DOCKER_LOCAL/etc
export DOCKER_CERT_PATH

docker_fetch_cli () {
    local docker_version=19.03.5
    local compose_version=1.25.0

    echo "++ fetching docker(1) CLI from https://download.docker.com"
    curl -sSkL $(printf "%s%s" \
        https://download.docker.com/linux/static/stable/x86_64/ \
        docker-${docker_version}.tgz) | \
        tar -z -x -f- --strip-components=1 -C $DOCKER_LOCAL/bin docker/docker
    chmod 755 $DOCKER_LOCAL/bin/docker

    echo "++ fetching docker-compose(1) CLI from https://github.com/docker/compose"
    curl -sSkL $(printf "%s%s" \
        https://github.com/docker/compose/releases/download/${compose_version}/ \
        docker-compose-Linux-x86_64) -o $DOCKER_LOCAL/bin/docker-compose
    chmod 755 $DOCKER_LOCAL/bin/docker-compose
}

docker_fetch_cred () {
    local host=$(echo "$DOCKER_HOST" | sed -e 's;^tcp://;;' -e 's;:.*$;;')
    echo "++ fetching docker(1) access credentials from root@$host:/etc/docker/"
	scp root@$host:/etc/docker/ca.crt     $DOCKER_LOCAL/etc/ca.pem
	scp root@$host:/etc/docker/client.crt $DOCKER_LOCAL/etc/cert.pem
	scp root@$host:/etc/docker/client.key $DOCKER_LOCAL/etc/key.pem
}

alias docker-fetch-cli=docker_fetch_cli
alias docker-fetch-cred=docker_fetch_cred

PATH=$DOCKER_LOCAL/bin:$PATH

