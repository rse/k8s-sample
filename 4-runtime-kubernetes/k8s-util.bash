#!/bin/bash
##
##  k8s-util.bash -- Kubernetes (K8S) Utility
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##

#   a temporary storage area
tmpfile="${TMPDIR-/tmp}/k8s-util.$$.tmp"

#   display verbose message
verbose () {
    echo "$*" 1>&2
}

#   handle fatal error
fatal () {
    echo "** ERROR: $*" 1>&2
    exit 1
}

#   fetch configuration
conf () {
    local id="$1"
    shift
    local cmd="sed -e \"1,/^%!${id}$/d\" -e \"/%!.*/,\\\$d\""
    for arg in "$@"; do
        local var=$(echo "$arg" | sed -e 's;=.*$;;')
        local val=$(echo "$arg" | sed -e 's;^[^=]*=;;')
        cmd="$cmd -e \"s;{{${var}}};${val};g\""
    done
    eval "$cmd" <"$(dirname ${BASH_SOURCE})/k8s-util.yaml" >$tmpfile
    sed -e "s;^;-- | ;" <$tmpfile 1>&2
    cat $tmpfile
    rm -f $tmpfile
}

#   create a namespace
cmd_create_namespace () {
    ns="$1"

    #   generate objects in Kubernetes
    verbose "++ create namespace \"$ns\""
    kubectl apply -f - < <(conf create-namespace ns="$ns")
}

#   create a cluster admin service account
cmd_create_cluster_admin () {
    ns="$1"; sa="$2"

    #   generate objects in Kubernetes
    verbose "++ create cluster admin service account \"$sa\" in namespace \"$ns\""
    kubectl apply -f - < <(conf create-cluster-admin ns="$ns" sa="$sa")
}

#   create a namespace admin service account
cmd_create_namespace_admin () {
    ns="$1"; sa="$2"

    #   generate objects in Kubernetes
    verbose "++ create namespace admin service account \"$sa\" in namespace \"$ns\""
    kubectl apply -f - < <(conf create-namespace-admin ns="$ns" sa="$sa")
    while [[ $(kubectl -n "$ns" get -l name="$sa" sa -o jsonpath --template='{.items[].secrets[].name}') == "" ]]; do
        sleep 0.25
    done
}

#   generate a K8S kubectl(1) configuration stub
#   (just for switching contexts)
cmd_generate_kubeconfig_stub () {
    cat <(conf generate-kubeconfig-stub)
}

#   generate a K8S kubectl(1) configuration
cmd_generate_kubeconfig () {
    ns="$1"; sa="$2"; context="$3"

    #   determine K8S API service UZL
    verbose "++ determine Kubernetes API service URL"
    local ctx=$(kubectl config current-context)
    local cluster=$(kubectl config view -o jsonpath="{.contexts[?(@.name == '$ctx')].context.cluster}")
    local server=$(kubectl config view -o jsonpath="{.clusters[?(@.name == '$cluster')].cluster.server}")
    verbose "-- URL: $server"

    #   determine a unique cluster id
    cluster=$(echo "$server" | sed -e 's;^https*://;;' -e 's;/.*$;;' -e 's;[^a-z0-9];-;g')
    verbose "-- Cluster-ID: $cluster"

    #   determine generated token of service account
    verbose "++ determine generated access token of service account \"$sa\""
    secret=$(kubectl -n "$ns" get sa "$sa" -o jsonpath="{.secrets[0].name}")
    token=$(kubectl -n "$ns" get secret "$secret" -o json | jq -r ".data.token | @base64d")

    #   generate K8S kubectl(1) configuration for service account
    verbose "++ generate kubectl(1) for service account \"$sa\" in namespace \"$ns\""
    cat <(conf generate-kubeconfig \
        ns="$ns" sa="$sa" server="$server" cluster="$cluster" token="$token" context="$context")
}

#   create deployment
cmd_create_deployment () {
    ns="$1"; name="$2"; image="$3"; port="$4"

    #   generate objects in Kubernetes
    verbose "++ create deployment for app \"$name\" (image: \"$image\", port: $port)"
    kubectl apply -f - < <(conf create-deployment \
        ns="$ns" name="$name" image="$image" port="$port")

    verbose "++ await deployment for app \"$name\""
    kubectl -n "$ns" wait --timeout=60s --for=condition=Available deployment.apps/$name
}

#   dispatch according to command
if [[ $# -eq 0 ]]; then
    set -- boot
fi
cmd="$1"; shift
eval "cmd_$(echo $cmd | sed -e 's;-;_;g')" "$@"
exit $?

