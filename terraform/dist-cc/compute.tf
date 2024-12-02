### CSail OpenStack

resource "openstack_compute_instance_v2" "csail_ccdist_master" {
  name = "ccdist-csail-master"
  image_id = openstack_images_image_v2.flatcar.id
  user_data = data.ct_config.machine-ignitions.rendered
  flavor_name = "lg.2core"
  security_groups = ["default", "ssh"]
  network {
    name = data.openstack_networking_network_v2.csail_inet.name
  }
  metadata = {
    "csail" = "true"
  }
}
