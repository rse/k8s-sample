/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

const os = require("os")

module.exports = (server /*, knex */) => {
    server.route({
        method:  "GET",
        path:    "/api/info",
        handler: async (request, h) => {
            const r = { host: {}, net: {}, proc: {}, env: [], header: [], peer: {} }

            /*  determine host information  */
            r.host = {
                hostname: os.hostname(),
                arch:     os.arch(),
                platform: os.platform(),
                type:     os.type(),
                release:  os.release()
            }

            /*  determine network information  */
            const ifaces = os.networkInterfaces()
            Object.keys(ifaces).forEach((iface) => {
                r.net[iface] = ifaces[iface].map((info) => info.cidr).join(", ")
            })

            /*  determine process information  */
            const argv = process.execArgv.concat(process.argv)
                .map((arg) => arg.match(/^\S+$/) ? arg : `"${arg.replace(/"/g, "\"")}"`)
                .join(" ")
            r.proc = {
                argv:     argv,
                cwd:      process.cwd(),
                pid:      process.pid,
                uid:      process.getuid(),
                gid:      process.getgid(),
                uptime:   Math.floor(process.uptime()),
                rss:      process.memoryUsage().rss
            }

            /*  determine environment information  */
            Object.keys(process.env).forEach((name) => {
                r.env.push({ name, value: process.env[name] })
            })

            /*  determine HTTP-header information  */
            Object.keys(request.headers).forEach((name) => {
                r.header.push({ name, value: request.headers[name] })
            })

            /*  determine peer information  */
            r.peer = {
                local:  request.info.host,
                remote: `${request.info.remoteAddress}:${request.info.remotePort}`
            }

            /*  determine container unique id  */
            r.id = `${r.proc.pid}@${r.host.hostname}`

            return r
        }
    })
}

