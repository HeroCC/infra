### CSail OpenStack

resource "openstack_compute_instance_v2" "csail_nodes" {
  for_each = var.nodes

  name            = each.key
  image_id        = openstack_images_image_v2.talos.id
  user_data       = data.talos_machine_configuration.node[each.key].machine_configuration
  config_drive    = true
  flavor_name     = each.value.flavor
  security_groups = ["default", "ssh", openstack_networking_secgroup_v2.talos.name]

  depends_on = [
    openstack_networking_router_interface_v2.attach_router_to_subnet,
  ]

  network {
    name = openstack_networking_network_v2.csail_ccdist_network.name
  }

  metadata = {
    "csail" = "true"
  }
}
