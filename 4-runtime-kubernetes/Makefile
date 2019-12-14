##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE         = sqlite
DATABASE_ENABLED = `echo "$(DATABASE)" | sed -e 's;^pgsql$$;true;' -e 's;^sqlite$$;false;'`

install:
	@cmd="helm install --set db.enabled=$(DATABASE_ENABLED) k8s-sample ."; echo "$$cmd"; $$cmd

status:
	helm status k8s-sample
	kubectl -n k8s-sample get all -l app=k8s-sample

await-install:
	kubectl -n k8s-sample wait --timeout=90s --for=condition=Available deployment/k8s-sample

await-uninstall:
	kubectl -n k8s-sample wait --timeout=90s --for=delete namespace/k8s-sample

logs:
	kubectl -n k8s-sample logs -l app=k8s-sample

uninstall:
	helm uninstall k8s-sample

