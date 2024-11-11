.PHONY: create_namespace delete_namespace build

NAMESPACE=k3s-apps

new_namespace:
	@echo "Creating new namespace"
	sudo kubectl create namespace $(NAMESPACE)

delete_namespace:
	@echo "Deleting namespace"
	sudo kubectl delete namespace $(NAMESPACE)

delete_all_namespaces:
	@echo "Deleting all namespaces"
	sudo bash -c 'kubectl get namespaces | grep -v NAME | awk "{print \$$1}" | xargs -I {} kubectl delete namespace {}'
build:
	nerdctl --address  /run/k3s/containerd/containerd.sock --namespace k8s.io build --tag hello-world:latest .
	# nerdctl --address  /run/k3s/containerd/containerd.sock build --tag hello-world:latest .
	# nerdctl tag hello-world:latest rpi5/hello-world:latest
	#  nerdctl push rpi5/hello-world:latest
	

test_launch:
	nerdctl run --rm --name hello-world -p 8080:80 localhost/hello-world:latest
start_registry:
	nerdctl system prune -f
	nerdctl run -d --name registry -p 5000:5000 registry:2
stop_registry:
	nerdctl stop registry
	
new_deployment:
	@echo "Creating new deployment"
	sudo kubectl create -f deployment.yaml --namespace $(NAMESPACE)

delete_deployment:
	@echo "Deleting deployment"
	sudo kubectl delete -f deployment.yaml --namespace $(NAMESPACE)

deploy_nginx:
	@echo "Deploying nginx"
	sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml

undeploy_nginx:
	@echo "Undeploying nginx"
	sudo kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml


new_expose:
	@echo "Creating new service"
	sudo kubectl expose deployment hello-world-deployment --name hello-world-service --port=8080 --target-port=80 -n k3s-apps

delete_expose:
	@echo "Deleting service"
	sudo kubectl delete service hello-world-service -n k3s-apps


new_ingress:
	@echo "Creating new ingress"
	sudo kubectl create ingress hello-world-ingress --class=nginx --rule="rpi5/*=hello-world-service:80" -n $(NAMESPACE)

delete_ingress:
	@echo "Deleting ingress"
	sudo kubectl delete ingress hello-world-ingress -n $(NAMESPACE)

new_map:
	@echo "Creating new map"
	sudo kubectl port-forward --address 0.0.0.0 --namespace=ingress-nginx service/ingress-nginx-controller 8081:80

delete_map:
	@echo "Deleting map"
	sudo kubectl delete port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8081:80

show_status:
	@echo "Showing status"
	sudo kubectl get deployments -n $(NAMESPACE)
	sudo kubectl get pods -n $(NAMESPACE)
	sudo kubectl get services -n $(NAMESPACE)

show_logs:
	@echo "Showing logs"
	sudo kubectl logs hello-world-deployment-78d58b7dc8-ft4k4 --all-containers --namespace $(NAMESPACE)

force_pod_terminate:
	@echo "Force pod terminate"
	sudo kubectl delete pod hello-world-deployment-74dc4c8b68-6glh6  --grace-period=0 --force --namespace $(NAMESPACE)

desc_pods:
	@echo "Showing pods"
	sudo kubectl describe pods -n $(NAMESPACE)
redeploy_k3s:
	
	# sudo cp config.toml.tmpl /var/lib/rancher/k3s/agent/etc/containerd/
	# sudo rm -f /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
	# sudo cp registries.yaml /var/lib/rancher/k3s/registries.yaml
	sudo mkdir -p /etc/rancher/k3s
	sudo cp registries.yaml /etc/rancher/k3s/registries.yaml
	sudo rm  -f /var/lib/rancher/k3s/registries.yaml
	sudo systemctl restart k3s

stop_k3s:
	sudo systemctl stop k3s

list_k3s_images:
	sudo k3s crictl images

prune_k3s_images:
	sudo k3s crictl rmi --prune
	
delete_k3s_images:
	sudo k3s crictl rmi --all

change_sock_perm:
	sudo chown root:alvin /run/k3s/containerd/containerd.sock