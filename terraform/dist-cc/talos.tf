resource "talos_machine_secrets" "cluster" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "node" {
  for_each = var.nodes

  cluster_name       = var.cluster_name
  machine_type       = each.value.role
  cluster_endpoint   = local.cluster_endpoint
  machine_secrets    = talos_machine_secrets.cluster.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = var.talos_install_disk
          image = data.talos_image_factory_urls.talos.urls.installer
        }
        network = {
          kubespan = {
            enabled = true
          }
        }
      }
      cluster = {
        discovery = {
          enabled = true
          registries = {
            kubernetes = {
              disabled = true
            }
            service = {}
          }
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "zerotier"
      environment = [
        "ZEROTIER_NETWORK=${zerotier_network.zt_homelab.id}",
        "ZEROTIER_IDENTITY_SECRET=${zerotier_identity.zerotier_node_identity[each.key].private_key}",
      ]
    })
  ]
}

data "talos_client_configuration" "cluster" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoints            = local.talos_controlplane_ips
  nodes                = values(local.zerotier_node_ips)
}

resource "talos_machine" "node" {
  for_each = var.nodes

  depends_on = [
    openstack_compute_instance_v2.csail_nodes,
    zerotier_member.zerotier_node_network_membership,
  ]

  node                            = local.zerotier_node_ips[each.key]
  endpoint                        = local.talos_bootstrap_ip
  client_configuration            = talos_machine_secrets.cluster.client_configuration
  machine_configuration           = data.talos_machine_configuration.node[each.key].machine_configuration
  image                           = data.talos_image_factory_urls.talos.urls.installer
  drain_on_upgrade                = false
  ignore_kubernetes_upgrade_drift = true
}

resource "talos_cluster" "cluster" {
  depends_on = [
    talos_machine.node,
  ]

  node                 = local.talos_bootstrap_ip
  endpoint             = local.talos_bootstrap_ip
  control_plane_nodes  = local.talos_controlplane_ips
  client_configuration = talos_machine_secrets.cluster.client_configuration
  kubernetes_version   = var.kubernetes_version
}

data "talos_cluster_health" "cluster" {
  depends_on = [
    talos_cluster.cluster,
  ]

  endpoints            = local.talos_controlplane_ips
  control_plane_nodes  = local.talos_controlplane_ips
  worker_nodes         = local.talos_worker_ips
  client_configuration = talos_machine_secrets.cluster.client_configuration
}

resource "talos_cluster_kubeconfig" "cluster" {
  depends_on = [
    data.talos_cluster_health.cluster,
  ]

  node                 = local.talos_bootstrap_ip
  endpoint             = local.talos_bootstrap_ip
  client_configuration = talos_machine_secrets.cluster.client_configuration
}
