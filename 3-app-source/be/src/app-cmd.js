/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

module.exports = (server, knex) => {
    /*  freeze  */
    server.route({
        method:  "GET",
        path:    "/api/cmd/freeze",
        handler: async (request, h) => {
            setTimeout(() => {
                process.stdout.write("-- freezing process (for 10 seconds)\n")
                const NS_PER_SEC = 1000000000n
                const start = process.hrtime.bigint()
                while (true) {
                    /*  perform a single bursts  */
                    /* eslint no-unused-vars: off */
                    let k = 0
                    for (let i = 0; i < 1e7; i++)
                        k++

                    /*  check whether we already bursted long enough  */
                    const end = process.hrtime.bigint()
                    if (((end - start) / NS_PER_SEC) > 10n)
                        break
                }
                process.stdout.write("-- unfreezing process\n")
            }, 100)
            return h.response().code(201)
        }
    })

    /*  terminate  */
    server.route({
        method:  "GET",
        path:    "/api/cmd/terminate",
        handler: async (request, h) => {
            setTimeout(() => {
                process.stdout.write("-- gracefully terminating process\n")
                process.exit(0)
            }, 100)
            return h.response().code(201)
        }
    })

    /*  crash  */
    server.route({
        method:  "GET",
        path:    "/api/cmd/crash",
        handler: async (request, h) => {
            setTimeout(() => {
                process.stdout.write("-- ungracefully terminating process\n")
                process.kill(process.pid)
            }, 100)
            return h.response().code(201)
        }
    })
}

