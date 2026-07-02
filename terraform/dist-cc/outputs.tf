output "talos_schematic_id" {
  value = talos_image_factory_schematic.talos.id
}

output "talos_image_id" {
  value = openstack_images_image_v2.talos.id
}

output "talos_image_name" {
  value = openstack_images_image_v2.talos.name
}

output "zerotier_management_ips" {
  value = local.zerotier_node_ips
}

output "cluster_endpoint" {
  value = local.cluster_endpoint
}

output "talosconfig" {
  value     = data.talos_client_configuration.cluster.talos_config
  sensitive = true
}

output "kubeconfig_raw" {
  value     = talos_cluster_kubeconfig.cluster.kubeconfig_raw
  sensitive = true
}
