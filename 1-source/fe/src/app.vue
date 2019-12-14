<!--
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
-->

<template>
    <md-app class="md-elevation-4" md-waterfall md-mode="fixed-last">
        <md-app-toolbar class="md-primary md-dense">
            <div class="md-toolbar-row">
                <span class="md-title">k8s-sample &mdash; Kubernetes Sample Application &nbsp; {{ id ? `(Id: ${id})` : "" }}</span>
            </div>
            <div class="md-toolbar-row">
                <md-tabs md-sync-route class="md-primary">
                    <md-tab
                        id="tab-info"
                        class="md-active"
                        md-label="View Information"
                        to="/info"
                    />
                    <md-tab
                        id="tab-todo"
                        md-label="Manage Todo List"
                        to="/todo"
                    />
                    <md-tab
                        id="tab-cmd"
                        md-label="Perform Commands"
                        to="/cmd"
                    />
                </md-tabs>
            </div>
        </md-app-toolbar>
        <md-app-content>
            <router-view />
        </md-app-content>
    </md-app>
</template>

<style>
html, body {
    background-color: #909090 !important;
}
.md-app {
    margin: 20px;
    height: 100%;
}
.md-tabs {
    width: 100%;
}
.md-toolbar .md-tabs {
    padding-left: 0 !important;
}
</style>

<script>
import bus from "./app-bus"

export default {
    name: "App",
    data: () => ({
        id: ""
    }),
    async created () {
        bus.$on("id", (id) => { this.id = id })
    }
}
</script>

