locals {
  gitops_path = "${path.module}/../../clusters/cc-dist"

  # Keep the controller pin and sync resources in GitOps, shared with Talos.
  flux_install_url = yamldecode(file("${local.gitops_path}/kustomization.yaml")).resources[0]

  flux_bootstrap_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeExternalManifestConfig"
      name       = "flux"
      url        = local.flux_install_url
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeInlineManifestConfig"
      name       = "flux-sops-keys"
      manifest = yamlencode({
        apiVersion = "v1"
        kind       = "Secret"
        metadata = {
          name      = "sops-keys"
          namespace = "flux-system"
        }
        type = "Opaque"
        data = {
          "age.agekey" = base64encode(var.sops_age_key)
        }
      })
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeInlineManifestConfig"
      name       = "flux-sync"
      manifest   = file("${local.gitops_path}/flux-system/gotk-sync.yaml")
    }),
  ]
}
