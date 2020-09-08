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

Get credentails for AKS cluster: az aks get-credentials -g rg-aks-rbac --name aks-rbac

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

Create cluster: `az aks create --resource-group rg-aks-rbac --name aks-rbac --kubernetes-version 1.18.6 --node-count 3 --enable-addons monitoring --generate-ssh-keys --enable-aad --aad-admin-group-object-ids fdf5c95d-a738-4234-87d2-df1dc92ac63b --network-plugin azure --vnet-subnet-id "${VNET_ID}" --docker-bridge-address 172.17.0.1/16 --dns-service-ip 10.200.0.10 --service-cidr 10.200.0.0/24`

Get ID of the group created manually in Azure portal:

Get User AD detals: `az ad group list`

Get AKS ID: `AKS_ID=$(az aks show -g rg-aks-rbac -n aks-rbac --query id -o tsv)`

Create Admin Role: `az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee fdf5c95d-a738-4234-87d2-df1dc92ac63b --scope $AKS_ID`

Get kubeclt config (kubeconfig): `az aks get-credentials --resource-group rg-aks-rbac --name aks-rbac --overwrite-existing`

Create namespace: `kubectl create namespace tripviewer`

Attach ACR to authenticate for AKS: `az aks update -n aks-rbac -g rg-aks-rbac --attach-acr registryoob9604`

`az aks update -n aks-rbac -g rg-aks-rbac --attach-acr registryoob9604`

Get credentials: `az aks get-credentials --resource-group rg-aks-rbac --name aks-rbac`

Quickly create disposable pod `kubectl run -it busybox --image=busybox -- sh` to ping `internal-vm`:

```
❯ kubectl run -it busybox --image=busybox -- sh

If you don't see a command prompt, try pressing enter.
/ # ping 10.2.0.4
PING 10.2.0.4 (10.2.0.4): 56 data bytes
64 bytes from 10.2.0.4: seq=0 ttl=64 time=1.878 ms
64 bytes from 10.2.0.4: seq=1 ttl=64 time=0.899 ms
64 bytes from 10.2.0.4: seq=2 ttl=64 time=1.145 ms
```