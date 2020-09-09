# Challenge 5 - Monitor and see how unstable it is

To check if a pod has been restarted you can check this by checking the RESTARTs column with this command:

`kubectl get pods -n tripapi -w`

To check why a pod was last restarted. You can check the messages or events

`kubectl describe pod -n tripapi <pod_name>`

## Adding Azure Monitor

We do this by either creating the cluster with `--enable-addons monitoring` on the `az aks create` command which is what we did when we built all of our clusters

[Guiide on how to enable monitoring](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-onboard)
