/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

const path  = require("path")
const HAPI  = require("@hapi/hapi")
const Inert = require("@hapi/inert")
const Knex  = require("knex")
const yargs = require("yargs")

const AppInfo = require("./app-info")
const AppTodo = require("./app-todo")
const AppCmd  = require("./app-cmd")

;(async () => {
    /*  parse command-line arguments  */
    const argv = yargs
        /* eslint indent: off */
        .usage("Usage: $0 [-d <database-file>] [-u <ui-directory>] [-a <address>] [-p <port>]")
        .help("h").alias("h", "help").default("h", false)
            .describe("h", "show usage help")
        .string("d").nargs("d", 1).alias("d", "database").default("d", "sqlite3:./app.sqlite")
            .describe("d", "database connection URL")
        .string("u").nargs("u", 1).alias("u", "ui").default("u", path.join(__dirname, "../../fe/dst"))
            .describe("u", "user-interface directory")
        .string("a").nargs("a", 1).alias("a", "address").default("a", "0.0.0.0")
            .describe("a", "listen IP address")
        .number("p").nargs("p", 1).alias("p", "port").default("p", 9090)
            .describe("p", "listen TCP port")
        .version(false)
        .strict()
        .showHelpOnFail(true)
        .demand(0)
        .parse(process.argv.slice(2))

    /*  use last supplied option only  */
    const reduce = (id1, id2) => {
        if (typeof argv[id1] === "object" && argv[id1] instanceof Array) {
            argv[id1] = argv[id1][argv[id1].length - 1]
            argv[id2] = argv[id2][argv[id2].length - 1]
        }
    }
    reduce("d", "database")
    reduce("u", "ui")
    reduce("a", "address")
    reduce("p", "port")

    /*  determine database connection  */
    process.stdout.write(`++ storing data to ${argv.database}\n`)
    const m = argv.database.match(/^([^:]+):(.+)$/)
    const connection = {}
    connection.client = m[1]
    connection.connection = m[2]
    if (!connection.connection.match(/^[^:]+:\/\//))
        connection.connection = { filename: connection.connection }

    /*  establish database access  */
    const knex = Knex({ ...connection, useNullAsDefault: true })

    /*  optionally create database schema  */
    const exists = await knex.schema.hasTable("config")
    if (!exists) {
        await knex.schema.createTable("config", (table) => {
            table.string("key").notNullable().unique()
            table.string("value").notNullable()
        })
        await knex.insert({ key: "schemaVersion", value: "1.0" }).into("config")
        await knex.schema.createTable("todo", (table) => {
            table.string("id").notNullable().unique()
            table.string("item").notNullable()
        })
    }

    /*  establish REST server  */
    process.stdout.write(`++ listening to http://${argv.address}:${argv.port}\n`)
    const server = HAPI.server({
        host:  argv.address,
        port:  argv.port,
        debug: { request: [ "error" ] }
    })

    /*  serve the static frontend  */
    await server.register(Inert)
    server.route({
        method: "GET",
        path: "/{param*}",
        handler: {
            directory: {
                path: argv.ui,
                redirectToSlash: true,
                index: true
            }
        }
    })

    /*  establish application-specific routes  */
    AppInfo(server, knex)
    AppTodo(server, knex)
    AppCmd(server, knex)

    /*  start REST server  */
    await server.start()

    /*  graceful termination handling  */
    const terminate = async (signal) => {
        process.stdout.write(`++ received ${signal} signal -- shutting down\n`)
        await server.stop()
        process.exit(0)
    }
    process.on("SIGINT",  () => terminate("INT"))
    process.on("SIGTERM", () => terminate("TERM"))
})().catch((err) => {
    /*  fatal error handling  */
    process.stderr.write(`ERROR: ${err.stack}\n`)
    process.exit(1)
})

