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