#  AKS

# Installation
## Create resource group:
`az group create --name rg-aks --location northeurope`

## Create cluster:
`az aks --resource-group rg-aks --name aks-test --kubernetes-version 1.17.9 --node-count 3 --enable-addons monitoring --generate-ssh-keys`

## Get kubeclt config:
`az aks get-credentials --resource-group rg-aks --name aks-test `

or override existing with:

`az aks get-credentials --resource-group rg-aks --name aks-test --overwrite-existing -a`

## Create namespace:

`kubectl create namespace tripviewer`

## Attach ACR to authenticate for AKS

`az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`

## Apply Deployment

Move to app deployment: `cd k8s/poi/`

Apply deployment file: `kubectl apply -f deployment.yaml`

Replace deployment file: `kubectl replace -f deployment.yaml`

Descript pod to get pod messages: `kubectl describte pod <uniquie_pod_id> -n <namespace>`

Get logs from the pod: `kubectl logs <uniquie_pod_id> -n <namespace>`

