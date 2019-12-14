<!--
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
-->

<template>
    <div class="info">
        On this page you can see various information gathered and
        provided by the server-side of this application. It allows you
        to inspect the particular environment this application runs
        inside. The information is rather low-level and intended for
        experts only. This is interesting to figure out details about
        the container run-time environment in case this application is
        deployed to a Docker host or Kubernetes cluster.
        <p />
        <div class="md-toolbar-row">
            <md-tabs class="md-secondary">
                <md-tab
                    id="tab-info-net"
                    md-label="Network"
                    to="/info/net"
                >
                    <md-table
                        v-model="net"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Network Information</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
                <md-tab
                    id="tab-info-host"
                    class="md-active"
                    md-label="Host"
                    to="/info/host"
                >
                    <md-table
                        v-model="host"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Host Information</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
                <md-tab
                    id="tab-info-proc"
                    md-label="Process"
                    to="/info/proc"
                >
                    <md-table
                        v-model="proc"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Process Information</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
                <md-tab
                    id="tab-info-env"
                    md-label="Environment"
                    to="/info/env"
                >
                    <md-table
                        v-model="env"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Environment Information (Environment Variables)</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
                <md-tab
                    id="tab-info-header"
                    md-label="Request"
                    to="/info/header"
                >
                    <md-table
                        v-model="header"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Request Information (HTTP Headers)</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
                <md-tab
                    id="tab-info-peer"
                    md-label="Peer"
                    to="/info/peer"
                >
                    <md-table
                        v-model="peer"
                        md-sort="name"
                        md-sort-order="asc"
                        md-fixed-header
                        md-card
                    >
                        <md-table-toolbar>
                            <md-subheader>Request Information (TCP/IP Peers)</md-subheader>
                        </md-table-toolbar>
                        <md-table-row slot="md-table-row" slot-scope="{ item }">
                            <md-table-cell class="name"  md-label="Name"  md-sort-by="name"><div class="name">{{ item.name }}</div></md-table-cell>
                            <md-table-cell class="value" md-label="Value" md-sort-by="value"><div class="value">{{ item.value }}</div></md-table-cell>
                        </md-table-row>
                    </md-table>
                </md-tab>
            </md-tabs>
        </div>
    </div>
</template>

<style scoped>
.md-table {
    width: 100%;
}
.md-card {
    margin-left: 0;
    margin-right: 0;
}
.md-table-cell {
    height: auto !important;
}
.md-table .md-table-cell.name {
    width: 300px;
}
.md-table .name {
    font-weight: bold;
    line-break: anywhere;
    word-break: break-all;
    white-space: pre-wrap;
    hyphens: auto;
}
.md-table .value {
    line-break: anywhere;
    word-break: break-all;
    white-space: pre-wrap;
    hyphens: auto;
}
</style>

<script>
import axios from "axios"
import bus   from "./app-bus"

export default {
    name: "AppInfo",
    data: () => ({
        net:    [],
        host:   [],
        proc:   [],
        env:    [],
        header: [],
        peer:   []
    }),
    async created () {
        const response = await axios.get("api/info")
        const sort = (arr) => arr.sort((a, b) => a.name.localeCompare(b.name))
        const map  = (map) => Object.keys(map).sort().map((name) => ({ name, value: map[name] }))
        this.net    = map(response.data.net)
        this.host   = map(response.data.host)
        this.proc   = map(response.data.proc)
        this.env    = sort(response.data.env)
        this.header = sort(response.data.header)
        this.peer   = map(response.data.peer)
        bus.$emit("id", response.data.id)
    }
}
</script>

