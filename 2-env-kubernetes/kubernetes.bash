##
##  kubernetes.bash -- Kubernetes CLI provisioning (for standard contexts)
##  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##
##  Usage:
##  | source kubernetes.bash
##  | kubectl ...
##

kubernetes_std () {
    #   provisioning base directory
    local basedir="$(cd $(dirname ${BASH_SOURCE}) && pwd)/kubernetes.d"
    if [[ ! -d "$basedir" ]]; then
        ( umask 022 && mkdir -p "$basedir/bin" "$basedir/etc" )
    fi

    #   provide path to etc directory
    kubernetes_etcdir="$basedir/etc"

    #   optionally extend the search path
    if [[ ! "$PATH" =~ (^|:)"$basedir/bin"(:|$) ]]; then
        PATH="$basedir/bin:$PATH"
    fi

    #   check for existence of kubectl(1) and helm(1)
    local which_kubectl=$(which kubectl)
    local which_helm=$(which helm)

    #   optionally download kubectl(1) and helm(1)
    if [[ -z "$which_kubectl" || -z "$which_helm" ]]; then
        #   ensure curl(1) is available
        if [[ -z "$(which curl)" ]]; then
            echo "** ERROR: require curl(1) utility to download files" 1>&2
            return 1
        fi

        #   download kubectl(1)
        if [[ -z "$which_kubectl" ]]; then
            local kubernetes_version=$(curl -sSkL \
                https://storage.googleapis.com/kubernetes-release/release/stable.txt)
            echo "++ downloading kubectl(1) CLI (version $kubernetes_version)"
            curl -sSkL -o $basedir/bin/kubectl $(printf "%s%s" \
                https://storage.googleapis.com/kubernetes-release/release/ \
                ${kubernetes_version}/bin/linux/amd64/kubectl)
            chmod 755 $basedir/bin/kubectl
        fi

        #   download helm(1)
        if [[ -z "$which_helm" ]]; then
            local helm_version=$(curl -sSkL https://github.com/kubernetes/helm/releases | \
                egrep 'releases/tag/v[0-9.]*"' | sed -e 's;^.*releases/tag/v;;' -e 's;".*$;;' | head -1)
            echo "++ downloading helm(1) CLI (version $helm_version)"
            curl -sSkL $(printf "%s%s" \
                https://get.helm.sh/ \
                helm-v${helm_version}-linux-amd64.tar.gz) | \
                tar -z -x -f - --strip-components=1 -C $basedir/bin linux-amd64/helm
            chmod 755 $basedir/bin/helm
        fi
    fi

    #   install Bash tab completions
    source <(kubectl completion bash)
    source <(helm completion bash)
}

kubernetes_std ${1+"$@"}
unset kubernetes_std

