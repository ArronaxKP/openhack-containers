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

Get pods to get Pod Name: `kubectl get pods -n tripviewer`

Descript pod to get pod messages: `kubectl describe pod pod-name -n tripviewer`

Get logs from the pod: `kubectl logs pod-name -n tripviewer`

### Adding a config map

We add environment variables to the pod for the DB credentials: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/

We create a config map to store environment variables: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables

`kubectl apply -f shared/configmap.yaml`

Get IP addresses from all services to populate `configmap.yaml` with correct endpoints: `kubectl get svc -n tripviewer`

### How to get onto a pod/container

These commands allow you to get onto a pod:
`-it` is the same as `--stdin --tty`. It is just the short commands

This commands jumps onto a pod but will run the default entrypoint (which may not always give you a terminal):
`kubectl exec -it pod-name -n tripviewer`

This commands jumps onto a pod but will /bin/sh to get a new terminal:
`kubectl exec --stdin --tty pod-name -n tripviewer -- /bin/bash`

How do I get out? If you get stuck in a container, the correct way to exit is to type `exit`
If you cannot get back to a terminal to type a command then press `cntl P + Q` to exit