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

Command to get VNET ID: `az network vnet subnet list --resource-group teamResources --vnet-name vnet --query "[0].id" --output tsv`

Set VNET_ID variable to use in Create command: `VNET_ID="$(az network vnet subnet list --resource-group teamResources --vnet-name vnet --query '[0].id' --output tsv)"`

Flags add to add aks to existing vnet

```
--network-plugin azure \
--vnet-subnet-id "${VNET_ID}" \
--docker-bridge-address 172.17.0.1/16 \
--dns-service-ip 10.2.0.10 \
--service-cidr 10.2.0.0/24 \
```

Remove RBAC Command as feature flag not enabled: `--enable-azure-rbac`

Create cluster: `az aks create --resource-group rg-aks-rbac --name aks-rbac --kubernetes-version 1.18.6 --node-count 3 --enable-addons monitoring --generate-ssh-keys --enable-aad --network-plugin azure --vnet-subnet-id "${VNET_ID}" --docker-bridge-address 172.17.0.1/16 --dns-service-ip 10.200.0.10 --service-cidr 10.200.0.0/24`














Get kubeclt config (kubeconfig): `az aks get-credentials --resource-group rg-aks --name aks-test --overwrite-existing `

Create namespace: `kubectl create namespace tripviewer`

Attach ACR to authenticate for AKS: `az aks update -n aks-test -g rg-aks --attach-acr registryoob9604`
