/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

import app         from "./app.vue"
import appInfo     from "./app-info.vue"
import appTodo     from "./app-todo.vue"
import appCmd      from "./app-cmd.vue"

import Vue         from "vue"
import VueRouter   from "vue-router"

import VueMaterial from "vue-material"
import "vue-material/dist/vue-material.min.css"
import "vue-material/dist/theme/default.css"

Vue.use(VueRouter)
Vue.use(VueMaterial)

const router = new VueRouter({
    routes: [
        { path: "/info", component: appInfo },
        { path: "/todo", component: appTodo },
        { path: "/cmd",  component: appCmd  },
        { path: "*",     redirect:  "/info" }
    ]
})

const App = new Vue({
    render: (h) => h(app),
    router
})

App.$mount("app")

