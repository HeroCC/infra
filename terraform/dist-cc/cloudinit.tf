data "gitlab_user_sshkeys" "user_ssh_keys" {
  for_each = toset(var.gitlab_ssh_user_ids)
  user_id  = each.value
}

data "template_file" "kairos_master" {
  template = "${file("${path.module}/cloud-init/kairos_master.yaml")}"

  vars = {}
}

data "template_file" "kairos_worker" {
  template = "${file("${path.module}/cloud-init/kairos.yaml")}"

  vars = {
    ssh_keys = yamlencode(toset([for keys in flatten([for user in data.gitlab_user_sshkeys.user_ssh_keys : user.keys]) : keys.key]))
  }
}

data "cloudinit_config" "kairos_master" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = data.template_file.kairos_master.rendered
  }

  part {
    content_type = "text/cloud-config"
    content = data.cloudinit_config.kairos_worker.rendered
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
  value = data.cloudinit_config.kairos_master.rendered 
}