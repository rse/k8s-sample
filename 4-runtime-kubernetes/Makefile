##
##  k8s-sample -- Kubernetes Sample Application
##  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
##  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
##

DATABASE         = sqlite
DATABASE_ENABLED = `echo "$(DATABASE)" | sed -e 's;^pgsql$$;true;' -e 's;^sqlite$$;false;'`

up:
	@cmd="helm install --set db.enabled=$(DATABASE_ENABLED) k8s-sample ."; echo "$$cmd"; $$cmd

status:
	helm status k8s-sample
	kubectl -n k8s-sample get all -l app=k8s-sample

logs:
	kubectl -n k8s-sample logs -l app=k8s-sample

down:
	helm uninstall k8s-sample

lint:
	helm lint .

package:
	helm package -d .. .

