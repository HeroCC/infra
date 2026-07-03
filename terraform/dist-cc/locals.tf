locals {
  node_names         = sort(keys(var.nodes))
  controlplane_nodes = [for name, node in var.nodes : name if node.role == "controlplane"]
  worker_nodes       = [for name, node in var.nodes : name if node.role == "worker"]

  zerotier_node_ips = {
    for name in local.node_names : name => "10.242.0.${index(local.node_names, name) + 50}"
  }

  talos_controlplane_ips = [
    for name in local.controlplane_nodes : local.zerotier_node_ips[name]
  ]

  talos_worker_ips = [
    for name in local.worker_nodes : local.zerotier_node_ips[name]
  ]

  talos_bootstrap_node = local.controlplane_nodes[0]
  talos_bootstrap_ip   = local.zerotier_node_ips[local.talos_bootstrap_node]
  cluster_endpoint     = "https://${local.talos_bootstrap_ip}:6443"
}
