https://managedkube.com/gitops/flux/weaveworks/guide/tutorial/2020/05/01/a-complete-step-by-step-guide-to-implementing-a-gitops-workflow-with-flux.html

https://github.com/fluxcd/flux/blob/master/chart/flux/README.md#

https://github.com/onedr0p/k3s-gitops/blob/master/deployments/flux/flux.yaml

https://github.com/ManagedKube/kubernetes-common-services/tree/master/kubernetes/helm/flux

```bash
helm upgrade -i flux fluxcd/flux --namespace flux --values ./values.yaml
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2
```
