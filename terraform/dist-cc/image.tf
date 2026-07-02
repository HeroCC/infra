resource "talos_image_factory_schematic" "talos" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = var.talos_image_extensions
      }
    }
  })
}

data "talos_image_factory_urls" "talos" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.talos.id
  platform      = "openstack"
}

resource "openstack_images_image_v2" "talos" {
  name             = "talos-${var.talos_version}-${substr(talos_image_factory_schematic.talos.id, 0, 12)}"
  image_source_url = data.talos_image_factory_urls.talos.urls.disk_image
  image_cache_path = "${path.module}/.terraform/image_cache"
  container_format = "bare"
  disk_format      = "raw"
  visibility       = "private"
  decompress       = true
}
