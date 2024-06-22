# resource "openstack_images_image_v2" "flatcar" {
#   name             = "flatcar-${var.flatcar_release_channel}-${var.flatcar_version}"
#   image_source_url = "https://${var.flatcar_release_channel}.release.flatcar-linux.net/amd64-usr/${var.flatcar_version}/flatcar_production_openstack_image.img.gz"
#   image_cache_path = "${path.module}/.terraform/image_cache" # use the local directory, otherwise every applying user will use their own $HOME
#   container_format = "bare"
#   disk_format      = "qcow2"
#   visibility       = "private"
#   decompress       = true
# }

data "http" "talos_image_hash_response" {
  url = "https://factory.talos.dev/schematics"
  method = "POST"
  request_body = file("${path.module}/talos/machine-image.yaml")
}

locals {
  talos_image_hash = jsondecode(data.http.talos_image_hash_response.response_body).id
  talos_image_version = "v1.6.4"
}

resource "openstack_images_image_v2" "talos" {
  name             = "talos-${local.talos_image_version}-${local.talos_image_hash}"
  image_source_url = "https://factory.talos.dev/image/${local.talos_image_hash}/${local.talos_image_version}/openstack-arm64.raw"
  image_cache_path = "${path.module}/.terraform/image_cache"
  container_format = "bare"
  disk_format      = "raw"
  visibility       = "private"
}

resource "openstack_images_image_v2" "kairos_ubuntu_24" {
  name            = "kairos-ubuntu-24"
  image_source_url = "https://github.com/kairos-io/kairos/releases/download/v3.0.13/kairos-ubuntu-24.04-standard-amd64-generic-v3.0.13-k3sv1.29.3+k3s1.iso"
  image_cache_path = "${path.module}/.terraform/image_cache"
  container_format = "bare"
  disk_format      = "iso"
}