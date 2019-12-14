/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

const os = require("os")

module.exports = (server /*, knex */) => {
    server.route({
        method:  "GET",
        path:    "/api/info",
        handler: async (request, h) => {
            const r = { host: {}, net: {}, proc: {}, env: [], header: [], peer: {} }
            r.host = {
                hostname: os.hostname(),
                arch:     os.arch(),
                platform: os.platform(),
                type:     os.type(),
                release:  os.release()
            }
            const ifaces = os.networkInterfaces()
            Object.keys(ifaces).forEach((iface) => {
                r.net[iface] = ifaces[iface].map((info) => info.cidr).join(", ")
            })
            const argv = process.execArgv.concat(process.argv)
                .map((arg) => arg.match(/^\S+$/) ? arg : `"${arg.replace(/"/g, "\"")}"`).join(" ")
            r.proc = {
                argv:     argv,
                cwd:      process.cwd(),
                pid:      process.pid,
                uid:      process.getuid(),
                gid:      process.getgid(),
                uptime:   Math.floor(process.uptime()),
                rss:      process.memoryUsage().rss
            }
            Object.keys(process.env).forEach((name) => {
                r.env.push({ name, value: process.env[name] })
            })
            Object.keys(request.headers).forEach((name) => {
                r.header.push({ name, value: request.headers[name] })
            })
            r.peer = {
                local:  request.info.host,
                remote: `${request.info.remoteAddress}:${request.info.remotePort}`
            }
            r.id = `${r.proc.pid}@${r.host.hostname}`
            return r
        }
    })
}

