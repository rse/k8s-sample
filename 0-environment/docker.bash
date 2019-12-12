##
##  docker.bash -- Docker CLI provisioning (for standard contexts)
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##
##  Usage:
##  | source docker.bash
##  | docker [...]
##  | docker-compose [...]
##

docker_std () {
    #   provisioning base directory
    local basedir="$(cd $(dirname ${BASH_SOURCE}) && pwd)/docker.d"
    if [[ ! -d "$basedir" ]]; then
        ( umask 022 && mkdir -p "$basedir/bin" "$basedir/etc" )
    fi

    #   provide path to etc directory
    docker_bindir="$basedir/bin"
    docker_etcdir="$basedir/etc"

    #   optionally extend the search path
    if [[ ! "$PATH" =~ (^|:)"$docker_bindir"(:|$) ]]; then
        PATH="$docker_bindir:$PATH"
    fi

    #   check for existence of docker(1) and docker-compose(1)
    local which_docker=$(which docker)
    local which_compose=$(which docker-compose)

    #   optionally download docker(1) and docker-compose(1)
    if [[ -z "$which_docker" || -z "$which_compose" ]]; then
        #   ensure curl(1) is available
        if [[ -z "$(which curl)" ]]; then
            echo "** ERROR: require curl(1) utility to download files" 1>&2
            return 1
        fi

        #   download docker(1)
        if [[ -z "$which_docker" ]]; then
            local docker_version=$(curl -sSkL https://github.com/docker/docker-ce/releases | \
                egrep 'releases/tag/v[0-9.]*"' | sed -e 's;^.*releases/tag/v;;' -e 's;".*$;;' | head -1)
            echo "++ downloading docker(1) CLI (version $docker_version)"
            curl -sSkL $(printf "%s%s" \
                https://download.docker.com/linux/static/stable/x86_64/ \
                docker-${docker_version}.tgz) | \
                tar -z -x -f- --strip-components=1 -C $docker_bindir docker/docker
            chmod 755 $docker_bindir/docker
        fi

        #   download docker-compose(1)
        if [[ -z "$which_compose" ]]; then
            local compose_version=$(curl -sSkL https://github.com/docker/compose/releases | \
                egrep 'releases/tag/[0-9.]*"' | sed -e 's;^.*releases/tag/;;' -e 's;".*$;;' | head -1)
            echo "++ downloading docker-compose(1) CLI (version $compose_version)"
            curl -sSkL $(printf "%s%s" \
                https://github.com/docker/compose/releases/download/${compose_version}/ \
                docker-compose-Linux-x86_64) -o $docker_bindir/docker-compose
            chmod 755 $docker_bindir/docker-compose
        fi
    fi
}

docker_std ${1+"$@"}
unset docker_std

