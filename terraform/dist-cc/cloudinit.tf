data "template_file" "kairos_master" {
  template = "${file("${path.module}/cloud-init/kairos.yaml")}"

  vars = {
    hostname = "metal-distcc-master"
    p2p_role = "master"
    edgevpn_token = yamlencode(var.edgevpn_token)
    sops_gpg = var.sops_gpg_key
  }
}

data "template_file" "kairos_worker" {
  template = "${file("${path.module}/cloud-init/kairos.yaml")}"

  vars = {
    hostname = "metal-distcc-worker"
    p2p_role = "worker"
    edgevpn_token = yamlencode(var.edgevpn_token)
    sops_gpg = var.sops_gpg_key
  }
}

data "template_cloudinit_config" "kairos_master" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = data.template_file.kairos_master.rendered
  }
}

data "cloudinit_config" "kairos_worker" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = data.template_file.kairos_worker.rendered
  }
}

output "kairos_master_cloudinit" {
  value = data.template_file.kairos_master.rendered
}