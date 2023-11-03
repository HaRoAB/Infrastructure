# Instructions

Create helm folder in Infrastructure folder.

```bash
helm create todo-app
```

- delete all files in template
- create files
    - deployment
    - service
    - config mapp
    - ingress

Apply the file to the cluster and check the result

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pod nginx-pod
```