# Challenge 4 - Key Vault and Nginx Controller

> How to check which cluster you are connected to: `kubectl config get-contexts`

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

## Create Azure Key Vault

Via the Portal -> Create a Resource -> Search Key Vault -> Create

Give it a neme -> next ... next ... next -> finish

Or we could have created it using the Azure CLI: `az keyvault create --name admiral-team2-kv --resource-group rg-aks-rbac`

Fix permission (we did this after creating the service principal). By default we should change it to use Azure Based Access Roles -> __Open key vault__ . Then go to the __Access Policies__ on the left hand side and tick the radial box `Azure role-based access control (preview)`. We could have done this when we created it via the UI or if we

Now we need to add the team as a Azure Key Vault Administrator. __Open key vault__ . Then go to the __Access Control (IAM)__ on the left hand side and and __+Add -> Role Assignment -> Select Key Vault Administratory Role (preview) -> And select team 2__

## Create Service principal

Give the servcice pack a name: `SPNAME="sp-aks-rbac"`

> OPTIONAL: Create a new service principal, be sure to notate the SP secret returned on creation

Create the SErvice Pack: `az ad sp create-for-rbac --skip-assignment --name $SPNAME`

Output:

```json
{
  "appId": "f8c46b1c-533e-4ac1-8471-54e6bff6cbf2",
  "displayName": "sp-aks-rbac",
  "name": "http://sp-aks-rbac",
  "password": "w3U5UWgLrWfWHWtI0Vpu7XihsHe-Ozjihw",
  "tenant": "6b29644a-06d8-48d2-80d8-360b0c87893c"
}
```

If you lose your AZURE_CLIENT_SECRET (SP Secret), you can reset and receive it with this command: `az ad sp credential reset --name $SPNAME --credential-description "APClientSecret" --query password -o tsv`

Set environment variables

```bash
AZURE_CLIENT_ID=$(az ad sp show --id http://${SPNAME} --query appId -o tsv)
KEYVAULT_NAME=admiral-team2-kv
KEYVAULT_RESOURCE_GROUP=rg-aks-rbac
SUBID=654efdd1-153d-49d5-8685-0f00758cc197
```

Assign Reader Role to the service principal for your keyvault: `az role assignment create --role Reader --assignee $AZURE_CLIENT_ID --scope /subscriptions/$SUBID/resourcegroups/$KEYVAULT_RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME`

```json
{
  "canDelegate": null,
  "id": "/subscriptions/654efdd1-153d-49d5-8685-0f00758cc197/resourcegroups/rg-aks-rbac/providers/Microsoft.KeyVault/vaults/admiral-team2-kv/providers/Microsoft.Authorization/roleAssignments/e7852701-87f1-47aa-993f-1198929e536f",
  "name": "e7852701-87f1-47aa-993f-1198929e536f",
  "principalId": "4e58a786-7561-4ca1-9119-30dc16809e1c",
  "principalType": "ServicePrincipal",
  "resourceGroup": "rg-aks-rbac",
  "roleDefinitionId": "/subscriptions/654efdd1-153d-49d5-8685-0f00758cc197/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7",
  "scope": "/subscriptions/654efdd1-153d-49d5-8685-0f00758cc197/resourcegroups/rg-aks-rbac/providers/Microsoft.KeyVault/vaults/admiral-team2-kv",
  "type": "Microsoft.Authorization/roleAssignments"
}
```

Add permissions to SP. if you are not using RBAC then use these permissions:

Add Key permission (no needed for our use case): `az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $AZURE_CLIENT_ID`

Add Key permission: `az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $AZURE_CLIENT_ID`

Add Certificate permission (no needed for our use case): `az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $AZURE_CLIENT_ID`

Create K8S secret with SP details to auth for Key Vault _don't miss the name space_: `kubectl create secret generic secrets-store-creds --from-literal clientid=f8c46b1c-533e-4ac1-8471-54e6bff6cbf2 --from-literal clientsecret=w3U5UWgLrWfWHWtI0Vpu7XihsHe-Ozjihw -n tripapi`

Also create secret in Tripviewer:
```
kubectl create secret generic secrets-store-creds \
  --from-literal clientid=f8c46b1c-533e-4ac1-8471-54e6bff6cbf2 \
  --from-literal clientsecret=w3U5UWgLrWfWHWtI0Vpu7XihsHe-Ozjihw \
  -n tripviewer
```

We fixed the key vault to use RBAC so we needed to fix the permissions on the service principal which we did through the portal. Giving it `Azure Key Vault Secret Reader` role to the user service principal - sp-aks-rbac

## Add Secrets on the volume

We added the CSI Class (see YAML file)

We tried setting ENV vars but got lost. So moved to using a volume mount instead (see YAML files)

Once we had the YAML correct we used this command to check the files mounted on the volume to check that the secrets were set

`kubectl exec -it -n tripapi poi-7c8548f7c-2kvfn -- ls /secrets`

We cound out we couldn't use underscores so we had to set the objectAlias to set the name correctly.

## Rebuild all deployments

We deleted all deployments:

```bash
kubectl delete -f deployment-poi.yaml
kubectl delete -f deployment-trips.yaml
kubectl delete -f deployment-tripviewer.yaml
kubectl delete -f deployment-user-java.yaml
kubectl delete -f deployment-userprofile.yaml
```

Re-deploy all deployments:

```bash
kubectl apply -f deployment-poi.yaml
kubectl apply -f deployment-trips.yaml
kubectl apply -f deployment-tripviewer.yaml
kubectl apply -f deployment-user-java.yaml
kubectl apply -f deployment-userprofile.yaml
```

## Create Nginx Ingress Controller

[As per instructions](https://docs.microsoft.com/en-us/azure/aks/ingress-basic)

Create a namespace for your ingress resources: `kubectl create namespace ingress-basic`

Add the ingress-nginx repository: `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`

Use Helm to deploy an NGINX ingress controller

```bash
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

Check ingress deployment is working:
`kubectl --namespace ingress-basic get services -o wide nginx-ingress-ingress-nginx-controller`


If we make a mistake you can delete the namespace to start again by running: `kubectl delete namespace ingress-basic`

If we change the name in the deployment yaml then we run `kubectl delete -f deployment.yaml` we will find it fails. That happens as it uses the name and namespace field to delete these obejcts. To then delete the object you must run `kubectl delete ingress <name> -n <namespace>`
