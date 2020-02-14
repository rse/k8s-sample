
k8s-sample &mdash; Kubernetes Sample Application
================================================

This is a sample application to showcase the software deployment on
the container run-time environments [Docker](https://www.docker.com/)
and [Kubernetes (K8S)](https://kubernetes.io/). The
sample application uses a Rich-Client architecture, comprised of an
[HTML5](https://en.wikipedia.org/wiki/HTML5) Single-Page Application
(SPA) client and a [Node.js](https://nodejs.org/) server and runs
under an arbitrary URL prefix. To showcase important run-time aspects,
the application shows detailed environment information, persists data
(both locally via [SQLite](https://www.sqlite.org/) and remotely
via [PostgreSQL](https://www.postgresql.org/)) and allows one to
control the application process. The application is packaged into a
[Docker](https://www.docker.com/) container and then this container
is deployed onto a [Docker](https://www.docker.com/) run-time
environment via [Docker-Compose](https://docs.docker.com/compose/) and
onto a [Kubernetes](https://kubernetes.io/) run-time environment via
[Helm](https://helm.sh/).

This project provides you the entire life-cycle: connecting and
bootstrapping the run-time environments, building and running the
application locally, building the application into a container
and deploying the container onto the run-time environments. On
the client side all this just needs a plain Linux/amd64 system
(e.g. [use Windows Subsystem for Linux (WSL) under Windows 10](https://github.com/rse/unix-under-windows))
with the [git(1)](https://git-scm.com/) and [curl(1)](https://curl.haxx.se/) programs installed. 
Everything is performed remotely, does not need any local privileges (including the local
downloaded client programs) and does not change the local Linux system
at all.

Sneak Preview
-------------

![k8s-sample screenshot](screenshot.png)

Quick Test-Drive
----------------

For standard contexts:

```sh
$ git clone https://github.com/rse/k8s-sample/                         # clone repository
$ cd k8s-sample                                                        # enter working copy
$ (cd 1-env-util && make)                                              # etablish environment utility
$ bash   2-env-setup/1-setup-std.bash <kubeconfig-file> [<docker-url>] # setup environment
$ source 2-env-setup/2-env.bash                                        # attach environment
$ source 2-env-setup/3-root.bash                                       # create cluster admin
$ source 2-env-setup/4-namespace.bash                                  # create application namespace
$ cd 6-run-kubernetes                                                  # enter Kubernetes deployment procedure
$ make install [DB_ENABLED=true]                                       # execute Kubernetes deployment procedure
$ open http[s]://<ingress-endpoint>/k8s-sample/                        # open deployed application
```

For special msg Project Server (PS) contexts
(where `<hostname>` is the FQDN of the msg Project Server instance
where you have SSH access to):

```sh
$ git clone https://github.com/rse/k8s-sample/     # clone repository
$ cd k8s-sample                                    # enter working copy
$ (cd 1-env-util && make)                          # etablish environment utility
$ bash   2-env-setup/1-setup-ps.bash <hostname>    # setup environment
$ source 2-env-setup/2-env.bash                    # attach environment
$ source 2-env-setup/3-root.bash                   # create cluster admin
$ source 2-env-setup/4-namespace.bash              # create application namespace
$ cd 6-runtime-kubernetes                          # enter Kubernetes deployment procedure
$ make install [DB_ENABLED=true]                   # execute Kubernetes deployment procedure
$ open http[s]://<hostname>/ase-k3s/k8s-sample/    # open deployed application
```

Short Background
----------------

On the application development side, the Docker and Kubernetes worlds
are primarily driven by four command-line client programs this
**k8s-sample** is using, too:

|            | low-level<br/>(commands) | high-level<br/>(stacks) |
|----------- | ------------------------ | ----------------------- |
| Docker     | `docker`                 | `docker-compose`        |
| Kubernetes | `kubectl`                | `helm`                  |

The Parts In Detail
-------------------

The **k8s-sample** consists of the following parts:

- **Kubernetes Environment Utility**: `1-env-util`<br/>
  Here you can find a procedure for locally installing the companion
  [**k8s-util(1)**](https://github.com/rse/k8s-util) utility. It ensures
  that the command-line clients for accessing a Docker and Kubernetes
  run-time environment are available and helps managing the
  run-time access credentials in the part `2-env-setup`:

    ```sh
    $ (cd 1-env-util && make)
    ```

- **Kubernetes Environment Setup**: `2-env-setup`<br/>
  Here you can find the scripts for establishing and attaching to the
  Kubernetes run-time environment.

  For standard contexts (arbitrary locally pre-existing Docker and
  remotely pre-existing Kubernetes installation), use the following
  command (where `<kubeconfig>` is the Kubernetes configuration of the
  admin account as manually fetched from the Kubernetes installation):

    ```sh
    $ bash 2-env-setup/1-setup-std.bash <kubeconfig> [<docker-url>]
    ```

  For msg Project Server (PS) contexts (where `<hostname>` is the
  hostname of the msg Project Server instance), instead the following
  command should be used (which installs the Rancher K3S software stack
  and uses both Docker and Kubernetes remotely):

    ```sh
    $ bash 2-env-setup/1-setup-ps.bash <hostname>
    ```

  Now we import the setup results into our shell environment with:

    ```sh
    $ source 2-env-setup/2-env.bash
    ```

  Then we create a cluster admin service account `root`, because
  applications like the official Kubernetes Dashboard allow
  authentication of "on-cluster" accounts only (instead of "off-cluster"
  account like the initial admin account):

    ```sh
    $ source 2-env-setup/3-root.bash
    ```

  Finally, we create a dedicated namespace (and corresponding namespace
  service account) `k8s-sample` for our application:

    ```sh
    $ source 2-env-setup/4-namespace.bash
    ```

- **Application Source Code**: `3-app-source`<br/>
  Here you can find the sources of the **k8s-sample** HTML5 SPA client and
  the corresponding Node.js server. Only used by you in case you want
  to understand and locally test-drive the application itself.

  ```sh
  $ (cd 3-app-source/fe && make build)
  $ (cd 3-app-source/be && make build start)
  ```

  After this you can access the application under `https://127.0.0.1:9090/`.
  You can stop the application with `CTRL+C`.

- **Application Container Build Procedure**: `4-app-container`<br/>
  Here you can find the procedure for building and packaging the
  **k8s-sample** application as a Docker/OCI container for use in both
  step 5 and 6. Only used by you in case you want to understand the
  Docker/OCI container packaging or build and push the container to
  your container image repository/registry (e.g. Docker Hub).

  ```sh
  $ (cd 4-app-container && make build push)
  ```

- **Docker Deployment Procedure**: `5-run-docker`<br/>
  Here you can find the procedure for installing the **k8s-sample**
  container (from step 4) onto a Docker run-time environment via the
  clients docker(1) and docker-compose(1).

  ```sh
  $ (cd 5-run-docker && make install [DATABASE=pgsql])
  ```

  After this you can access the application under `http://<hostname>:9090/`.
  You can uninstall the application again with:

  ```sh
  $ (cd 5-run-docker && make uninstall)
  ```

- **Kubernetes Deployment Procedure**: `6-run-kubernetes`<br/>
  Here you can find the procedure for installing the **k8s-sample**
  container (from step 4) onto a Kubernetes run-time environment via the
  clients kubectl(1) and helm(1).

  ```sh
  $ (cd 6-run-kubernetes && make install [DB_ENABLED=true])
  ```

  After this you can access the application under `http://<endpoint>/k8s-sample/`
  where `<endpoint>` is your Kubernetes ingress endpoint. For a msg Project Server
  with the K3S Kubernetes stack, the URL is `http://<hostname>/ase-k3s/k8s-sample/`
  where `<hostname>` is your msg Project Server instance.
  You can uninstall the application again with:

  ```sh
  $ (cd 6-run-kubernetes && make uninstall)
  ```

License
-------

Copyright &copy; 2019-2020 Dr. Ralf S. Engelschall (http://engelschall.com/)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

