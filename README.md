
k8s-sample
==========

This is a sample application for testing the deployment on the
container run-times Docker and Kubernetes (K8S). The application uses a
Rich-Client architecture, comprised of an HTML5 Single-Page Application
(SPA) client and a Node.js server and runs under an arbitrary URL
prefix.

Establish Environment
=====================

In order to test-drive this application the CLIs for accessing a Docker
and/or Kubernetes run-time envionment is required. Two Bash scripts help
you to provision those CLIs locally under Linux (amd64) systems.

- For standard contexts:

  ```sh
  $ source 0-environment/docker.bash
  $ source 0-environment/kubernetes.bash
  ```

- For special msg Project Server (PS) contexts:

  ```sh
  $ source 0-environment/docker-ps.bash <hostname>
  $ source 0-environment/kubernetes-ps.bash <hostname>
  ```

