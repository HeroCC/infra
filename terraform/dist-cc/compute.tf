### CSail OpenStack

resource "openstack_compute_instance_v2" "csail_ccdist_master" {
  name = "ccdist-csail-master"
  //image_name = openstack_images_image_v2.kairos_ubuntu_24.name
  flavor_name = "lg.2core"
  security_groups = ["default", "ssh"]
  network {
    name = "inet"
  }
  metadata = {
    "csail" = "true"
  }

  // https://blog.andyserver.com/2021/06/booting-iso-in-openstack-environments/
  block_device {
    // Used on all subsequent boots
    source_type           = "blank"
    destination_type      = "volume"
    device_type           = "disk"
    volume_size           = 30
    boot_index            = 0
    delete_on_termination = true
  }

  // https://docs.openstack.org/nova/latest/user/block-device-mapping.html
  block_device {
    // Boot from "CD" volume & install
    uuid                  = openstack_images_image_v2.kairos_ubuntu_24.id
    source_type           = "image"
    device_type           = "cdrom"
    volume_size           = 5
    boot_index            = 1
    destination_type      = "volume"
    delete_on_termination = true
  }
  user_data = data.template_file.kairos_master.rendered
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
