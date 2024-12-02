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

# resource "openstack_blockstorage_volume_v3" "kairos_install_volume" {
#   name = "kairos-install-volume"
#   size = 4
#   image_id = openstack_images_image_v2.kairos_ubuntu_24.id
# }

# resource "openstack_compute_volume_attach_v2" "kairos_install_attachment" {
#   instance_id = openstack_compute_instance_v2.csail_ccdist_master.id
#   volume_id = openstack_blockstorage_volume_v3.kairos_install_volume.id
#   device = "/dev/vdb"
# }
