# Challenge 5 - Monitor and see how unstable it is

To check if a pod has been restarted you can check this by checking the RESTARTs column with this command:

`kubectl get pods -n tripapi -w`

To check why a pod was last restarted. You can check the messages or events

`kubectl describe pod -n tripapi <pod_name>`

## Create Two namespaces
