These YAML files are used to bootstrap the K8s environment needed to
run the k8s-sample application. They
- create the namespace
- create the service account for this namespace
- create a secret for this service account so that kubectl can authenticate

The YAML files have to be applied (using `kubectl apply`) in the order given
by their filename.
