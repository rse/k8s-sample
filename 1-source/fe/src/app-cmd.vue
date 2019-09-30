<!--
**  Sample -- Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
-->

<template>
    <div class="cmd">
        On this page you can perform some commands on the server-side.
        Currently, it allows the server-side to temporarily freeze (for 10 seconds), gracefully terminate or
        ungracefully crash.
        This is interesting to show-case the automatic re-instantiation
        of the application in case this application is deployed onto a
        Docker host or Kubernetes cluster.
        <p />
        <md-button @click="freeze()" class="md-raised md-primary">Freeze (10s)</md-button>
        <md-button @click="terminate()" class="md-raised md-accent">Terminate</md-button>
        <md-button @click="crash()" class="md-raised md-accent">Crash</md-button>
    </div>
</template>

<style scoped>
.cmd {
}
</style>

<script>
import axios from "axios"

export default {
    name: "AppCmd",
    methods: {
        async freeze (item) {
            await axios.get("api/cmd/freeze")
        },
        async terminate (item) {
            await axios.get("api/cmd/terminate")
        },
        async crash (item) {
            await axios.get("api/cmd/crash")
        }
    }
}
</script>

