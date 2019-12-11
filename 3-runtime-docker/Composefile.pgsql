##
##  Sample -- Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

version: "3.7"

services:

    #   the Sample application
    sample-app:
        container_name: sample-app
        image:          docker.pkg.github.com/rse/k8s-sample/k8s-sample:0.9.0-20190930
        command:        -a 0.0.0.0 -p 9090 -d pg:postgres://app:app@db/app -w 10
        init:           true
        restart:        always
        volumes:
            - sample-app:/data
        networks:
            - sample
        depends_on:
            - sample-db
        ports:
            - 9090:9090

    #   the PostgreSQL database
    sample-db:
        container_name: sample-db
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
            - sample-db:/data
        networks:
            sample: { aliases: [ db ] }

volumes:
    sample-app:
        name: sample-app
    sample-db:
        name: sample-db

networks:
    sample:
        name: sample
        driver: bridge

