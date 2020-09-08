# Challenge 3 - Setup an AKS with RBAC and VNET

## Create Two namespaces

(already exists from challenge 3) Create namespace: `kubectl create namespace tripviewer`
Create namespace: `kubectl create namespace tripapi`

(already exists from challenge 3) Attach ACR to authenticate for AKS: `az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`

Get credentials: `az aks get-credentials --resource-group rg-aks-rbac --name aks-rbac`
