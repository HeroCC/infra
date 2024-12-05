### CSail OpenStack

resource "openstack_compute_instance_v2" "csail_nodes" {
  for_each = var.nodes

  name = each.key
  image_id = openstack_images_image_v2.flatcar.id
  user_data = data.ct_config.flatcar_template[each.key].rendered
  flavor_name = each.value.flavor
  security_groups = ["default", "ssh"]
  network {
    name = openstack_networking_network_v2.csail_ccdist_network.name
  }
  metadata = {
    "csail" = "true"
  }
}
