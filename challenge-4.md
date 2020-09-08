# Challenge 3 - Setup an AKS with RBAC and VNET

## Create Two namespaces

(already exists from challenge 3) Create namespace: `kubectl create namespace tripviewer`
Create namespace: `kubectl create namespace tripapi`

(already exists from challenge 3) Attach ACR to authenticate for AKS: `az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`

Get credentials: `az aks get-credentials --resource-group rg-aks-rbac --name aks-rbac`


Create Role and Role binding files:

Get Group IDs using Azure AD: `az ad group list`

web-dev: `58914ddf-0dbf-4095-9b8a-334ba9bdb2ef`

api-dev: `1041487b-febc-4e13-b1fe-83076daf7852`

team2: `fdf5c95d-a738-4234-87d2-df1dc92ac63b`

