data "cloudinit_config" "kairos_master" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/cloud-init/kairos_master.yaml")
  }

  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/cloud-init/kairos.yaml")
  }
}

data "cloudinit_config" "kairos_worker" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/cloud-init/kairos.yaml")
  }
}