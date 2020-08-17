```bash
kubectl apply -f _namespace.yaml
```

## flux base operator
https://managedkube.com/gitops/flux/weaveworks/guide/tutorial/2020/05/01/a-complete-step-by-step-guide-to-implementing-a-gitops-workflow-with-flux.html
https://github.com/fluxcd/flux/blob/master/chart/flux/README.md#
https://github.com/onedr0p/k3s-gitops/blob/master/deployments/flux/flux.yaml
https://github.com/ManagedKube/kubernetes-common-services/tree/master/kubernetes/helm/flux

```bash
helm upgrade -i flux fluxcd/flux --namespace flux --values ./flux-values.yaml
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2
```

## flux helm operator
https://github.com/fluxcd/helm-operator-get-started
https://github.com/ManagedKube/kubernetes-common-services/blob/master/docs/setup-guide.md#deploy-the-flux-helm-operator
https://github.com/fluxcd/helm-operator/blob/master/chart/helm-operator/README.md

```bash
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
helm upgrade -i helm-operator fluxcd/helm-operator --wait --namespace flux --values ./helm-operator-values.yaml
```
