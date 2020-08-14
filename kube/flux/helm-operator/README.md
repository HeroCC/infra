https://github.com/fluxcd/helm-operator-get-started
https://github.com/ManagedKube/kubernetes-common-services/blob/master/docs/setup-guide.md#deploy-the-flux-helm-operator
https://github.com/fluxcd/helm-operator/blob/master/chart/helm-operator/README.md
```bash
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
helm upgrade -i helm-operator fluxcd/helm-operator --wait --namespace flux --values ./values.yaml
```
