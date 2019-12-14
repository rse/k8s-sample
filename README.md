
k8s-sample &mdash; Kubernetes Sample Application
================================================

This is a sample application for testing the deployment on the
container run-times Docker and Kubernetes (K8S). The application uses a
Rich-Client architecture, comprised of an HTML5 Single-Page Application
(SPA) client and a Node.js server and runs under an arbitrary URL
prefix. The application shows environment information, persists
data and can control the application process.

![k8s-sample screenshot](screenshot.png)

Understanding and Using the Parts
---------------------------------

The **k8s-sample** consts of the following parts:

- `0-environment`:<br/>
  Here you can find scripts for establishing your local Docker and/or
  Kubernetes environment. In order to build and deploy **k8s-sample**,
  the command-line clients for accessing a Docker and/or Kubernetes
  run-time environment are required. Four Bash scripts help you to
  provision those command-line clients locally under Linux (amd64)
  systems.

  - For standard contexts:

    ```sh
    $ source 0-environment/docker.bash
    $ source 0-environment/kubernetes.bash
    ```

  - For special msg Project Server (PS) contexts (where `<hostname>` is the
    hostname of the msg Project Server instance) where the K3S Kubernetes
    stack was installed with `docker-stack install ase-k3s`:

    ```sh
    $ source 0-environment/docker-ps.bash     <hostname>
    $ source 0-environment/kubernetes-ps.bash <hostname>
    ```

- `1-source`:<br/>
  Here you can find the sources of the **k8s-sample** HTML5 SPA client and
  the corresponding Node.js server. Only used by you in case you want
  to understand and locally test-drive the application itself.

  ```sh
  $ (cd 1-source/fe && make build)
  $ (cd 1-source/be && make build start)
  ```

  After this you can access the application under `https://127.0.0.1:9090/`.
  You can stop the application with `CTRL+C`.

- `2-image`:<br/>
  Here you can find the procedure for building and packaging the
  **k8s-sample** application as a Docker container. Only used by you in
  case you want to understand the Docker container packaging or
  build and push the container to Docker Hub.

  ```sh
  $ (cd 2-image && make build push)
  ```

- `3-runtime-docker`:<br/>
  Here you can find the procedure for installing **k8s-sample** onto
  a Docker run-time environment via the clients docker(1) and docker-compose(1).

  ```sh
  $ (cd 3-runtime-docker && make install)
  ```

  After this you can access the application under `http://<hostname>:9090/`.
  You can uninstall the application again with:

  ```sh
  $ (cd 3-runtime-docker && make uninstall)
  ```

- `4-runtime-kubernetes`:<br/>
  Here you can find the procedure for installing **k8s-sample** onto
  a Kubernetes run-time environment via the clients kubectl(1) and helm(1).

  ```sh
  $ (cd 4-runtime-kubernetes && make install)
  ```

  After this you can access the application under `http://<endpoint>/k8s-sample/`
  where `<endpoint>` is your Kubernetes ingress endpoint. For a msg Project Server
  with the K3S Kubernetes stack, the URL is `http://<hostname>/ase-k3s/k8s-sample/`
  where `<hostname>` is your msg Project Server instance.
  You can uninstall the application again with:

  ```sh
  $ (cd 4-runtime-kubernetes && make uninstall)
  ```

