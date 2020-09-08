# Challenge 2 - Setup an AKS

## Installation

## Login to Azure CLI

Login to az cli: `az login`

### Create resource group:

`az group create --name rg-aks --location northeurope`

### Create cluster:

`az aks --resource-group rg-aks --name aks-test --kubernetes-version 1.17.9 --node-count 3 --enable-addons monitoring --generate-ssh-keys`

### Get kubeclt config (kubeconfig):

`az aks get-credentials --resource-group rg-aks --name aks-test `

or override existing with:

`az aks get-credentials --resource-group rg-aks --name aks-test --overwrite-existing -a`

### Create namespace:

`kubectl create namespace tripviewer`

### Attach ACR to authenticate for AKS

`az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`

### Apply Deployment

Move to app deployment: `cd k8s/poi/`

Apply deployment file: `kubectl apply -f deployment.yaml`

Delete deployment file: `kubectl delete -f deployment.yaml`

Replace deployment file: `kubectl replace -f deployment.yaml`

### Check Pod Deployment

Get pods to get Pod Unique ID: `kubectl get pods -n tripviewer`

Descript pod to get pod messages: `kubectl describe pod <uniquie_pod_id> -n tripviewer`

Get logs from the pod: `kubectl logs <uniquie_pod_id> -n tripviewer`

### Adding a config map

We add environment variables to the pod for the DB credentials: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/

We create a config map to store environment variables: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables

`kubectl apply -f shared/configmap.yaml`

Get IP addresses from all services to populate `configmap.yaml` with correct endpoints: `kubectl get svc -n tripviewer`