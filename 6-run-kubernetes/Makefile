##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE           = sqlite
DATABASE_ENABLED   = `echo "$(DATABASE)" | sed -e 's;^pgsql$$;true;' -e 's;^sqlite$$;false;'`
REPLICAS           = 1

install:
	@cmd="helm install"; \
	    cmd="$$cmd --set db.enabled=$(DATABASE_ENABLED)"; \
	    cmd="$$cmd --set app.container.replicas=$(REPLICAS)"; \
	    cmd="$$cmd k8s-sample ."; \
	    echo "$$cmd"; $$cmd
	kubectl -n k8s-sample wait --timeout=90s --for=condition=Available deployment/k8s-sample-app

status:
	helm status k8s-sample
	kubectl -n k8s-sample get all -l app=k8s-sample

logs:
	kubectl -n k8s-sample logs -l app=k8s-sample

uninstall:
	helm uninstall k8s-sample
	kubectl -n k8s-sample wait --timeout=90s --for=delete namespace/k8s-sample

