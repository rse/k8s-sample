/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

const UUID = require("pure-uuid")

module.exports = (server, knex) => {
    /*  create  */
    server.route({
        method:  "POST",
        path:    "/api/todo",
        handler: async (request, h) => {
            const item = {}
            item.id   = (new UUID(1)).format("std")
            item.item = request.payload.item
            await knex("todo").insert(item)
            return item
        }
    })

    /*  read  */
    server.route({
        method:  "GET",
        path:    "/api/todo",
        handler: async (request, h) => {
            const items = await knex("todo").select("id", "item")
            return items
        }
    })

    /*  update  */
    server.route({
        method:  "PUT",
        path:    "/api/todo/{id}",
        handler: async (request, h) => {
            const item = {}
            item.id   = request.params.id
            item.item = request.payload.item
            await knex("todo").where({ id: item.id }).update({ item: item.item })
            return item
        }
    })

    /*  delete  */
    server.route({
        method:  "DELETE",
        path:    "/api/todo/{id}",
        handler: async (request, h) => {
            const id = request.params.id
            await knex("todo").where({ id }).del()
            return h.response().code(201)
        }
    })
}

