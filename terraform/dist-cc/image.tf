# Create the OpenStack image by importing directly from the release servers
resource "openstack_images_image_v2" "flatcar" {
  name             = "flatcar-${var.flatcar_release_channel}-${var.flatcar_version}"
  image_source_url = "https://${var.flatcar_release_channel}.release.flatcar-linux.net/amd64-usr/${var.flatcar_version}/flatcar_production_openstack_image.img.gz"
  image_cache_path = "${path.module}/.terraform/image_cache"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "private"
  decompress       = true
}
