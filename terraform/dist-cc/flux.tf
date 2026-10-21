locals {
  gitops_path = "${path.module}/../../clusters/cc-dist"

  # Keep the controller pin and sync resources in GitOps, shared with Talos.
  flux_install_url = yamldecode(file("${local.gitops_path}/kustomization.yaml")).resources[0]

  flux_bootstrap_manifests = [
    {
      name = "flux-sops-keys"
      contents = yamlencode({
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
    },
    {
      name     = "flux-sync"
      contents = file("${local.gitops_path}/flux-system/gotk-sync.yaml")
    },
  ]
}
