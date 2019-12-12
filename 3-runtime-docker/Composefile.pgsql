##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

version: "3.7"

services:

    #   the k8s-sample application
    k8s-sample-app:
        container_name: k8s-sample-app
        image:          docker.io/engelschall/k8s-sample:0.9.0-20191212
        command:        -a 0.0.0.0 -p 9090 -d pg:postgres://app:app@db/app -w 10
        init:           true
        restart:        always
        volumes:
            - k8s-sample-app:/data
        networks:
            - k8s-sample
        depends_on:
            - k8s-sample-db
        ports:
            - 9090:9090

    #   the k8s-sample database
    k8s-sample-db:
        container_name: k8s-sample-db
        image:          docker.msg.team/ps/std-postgresql:12.1-20191114
        init:           true
        restart:        always
        environment:
            CFG_ADMIN_USERNAME:  postgresql
            CFG_ADMIN_PASSWORD:  postgresql
            CFG_CUSTOM_DATABASE: app
            CFG_CUSTOM_USERNAME: app
            CFG_CUSTOM_PASSWORD: app
        volumes:
            - k8s-sample-db:/data
        networks:
            k8s-sample: { aliases: [ db ] }

volumes:
    k8s-sample-app:
        name: k8s-sample-app
    k8s-sample-db:
        name: k8s-sample-db

networks:
    k8s-sample:
        name: k8s-sample
        driver: bridge

