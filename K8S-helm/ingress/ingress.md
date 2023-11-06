

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/ controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml

kubectl patch service/ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "NodePort"}}'

