# Challenge 5 - Monitor and see how unstable it is

To check if a pod has been restarted you can check this by checking the RESTARTs column with this command:

`kubectl get pods -n tripapi -w`

To check why a pod was last restarted. You can check the messages or events

`kubectl describe pod -n tripapi <pod_name>`

## Adding Azure Monitor

We do this by either creating the cluster with `--enable-addons monitoring` on the `az aks create` command which is what we did when we built all of our clusters

[Guiide on how to enable monitoring](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-onboard)

## Set up Azure Monitor Agent

Using this guide page - https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-agent-config

Added the configmap approach to connect to Azure Monitor (abandoned and gone to below option)

## Add prometheus opersator

Ran this command

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
helm install prometheus --namespace monitoring stable/prometheus-**operator**
```

This failed so ran these commands:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
helm install prometheus --namespace monitoring stable/prometheus-operator --set prometheusOperator.createCustomResource=false
```
