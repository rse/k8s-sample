<!--
**  k8s-sample ~ Kubernetes Sample Application
**  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
-->

<template>
    <div class="todo">
        On this page you can manage a simple to-do list for illustration
        purposes and to proof that this application has a true
        persistence layer on the server-side. This is interesting
        to show-case the persistent volume management in case this
        application is deployed onto a Docker host or Kubernetes
        cluster.
        <p />
        <md-field v-for="(item, index) in items" :key="item.id">
           <md-input v-model="item.item" :data-index="index" />
           <md-button @click="update(item)" class="md-raised md-primary">Change</md-button>
           <md-button @click="del(item)" class="md-raised md-accent">Delete</md-button>
        </md-field>
        <md-field>
           <md-input v-model="added" />
           <md-button @click="add()" class="md-raised md-primary">Add</md-button>
        </md-field>
    </div>
</template>

<style scoped>
.todo {
}
.md-field {
    margin: 2px 0 2px 0;
}
</style>

<script>
import axios from "axios"

export default {
    name: "AppTodo",
    data: () => ({
        added: "",
        items: []
    }),
    methods: {
        async update (item) {
            await axios.put(`api/todo/${item.id}`, {
                item: item.item
            })
        },
        async del (item) {
            await axios.delete(`api/todo/${item.id}`)
            this.items = this.items.filter((x) => x.id !== item.id)
        },
        async add () {
            const response = await axios.post("api/todo", {
                item: this.added
            })
            this.items.push(response.data)
            this.added = ""
        }
    },
    async created () {
        const response = await axios.get("api/todo")
        this.items = response.data
    }
}
</script>

