# Challenge 3 - Setup an AKS with RBAC and VNET

## Create Two namespaces

(already exists from challenge 3) Create namespace: `kubectl create namespace tripviewer`
Create namespace: `kubectl create namespace tripapi`

(already exists from challenge 3) Attach ACR to authenticate for AKS: `az aks update -n aks-rbac -g rg-aks-rbac --attach-acr registryoob9604`

Get credentials: `az aks get-credentials -g rg-aks-rbac --name aks-rbac`

Apply all deployment files: `kubectl apply -f *.yaml`

Delete all deployment files: `kubectl delete -f *.yaml`

Create Role and Role binding files:

Get Group IDs using Azure AD: `az ad group list`

* web-dev: `58914ddf-0dbf-4095-9b8a-334ba9bdb2ef`
* api-dev: `1041487b-febc-4e13-b1fe-83076daf7852`
* team2: `fdf5c95d-a738-4234-87d2-df1dc92ac63b`

## Managing users and groups

Create New user: `Go to Active Directory -> User Tab -> New User -> Fill in details (domain is already set)`

We then need to add the user to our subscription: https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal

Add user to role: `Go to Subscription -> IAM -> Role Assignments -> Add -> Add Role Assignment -> Type User name in select field -> pick user`

