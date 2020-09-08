# Challenge 3 - Setup an AKS with RBAC and VNET

## Installation

## Install the aks-preview extension
`az extension add --name aks-preview`

## Update the extension to make sure you have the latest version installed
`az extension update --name aks-preview`

## HJow to check if preview feature is enabled:

Feature name: Microsoft.ContainerService/EnableAzureRBACPreview

`az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableAzureRBACPreview')].{Name:name,State:properties.state}"`

## Create new cluster

Login to az cli: `az login`

Create resource group: `az group create --name rg-aks-rbac --location northeurope`

Check what version of k8s you can use (can also check via portal): `az aks get-versions --location eastus --output table`

Add `--enable-aad --enable-azure-rbac` to add new RBAC capabilities

az network vnet subnet list --resource-group teamresource --vnet-name vnet --query "[0].id" --output tsv

```
--network-plugin azure \
--vnet-subnet-id <subnet-id> \
--docker-bridge-address 172.17.0.1/16 \
--dns-service-ip 10.2.0.10 \
--service-cidr 10.2.0.0/24 \
```

Create cluster: `az aks --resource-group rg-aks --name aks-test --kubernetes-version 1.18.6 --node-count 3 --enable-addons monitoring --generate-ssh-keys --enable-aad --enable-azure-rbac`

Get kubeclt config (kubeconfig): `az aks get-credentials --resource-group rg-aks --name aks-test --overwrite-existing `

Create namespace: `kubectl create namespace tripviewer`

Attach ACR to authenticate for AKS: `az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`
