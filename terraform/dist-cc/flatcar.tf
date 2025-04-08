resource "random_id" "k3s_server_token" {
  byte_length = 35
}

resource "random_id" "k3s_agent_token" {
  byte_length = 32
}

data "template_file" "flatcar_template" {
  for_each = var.nodes

  template = file("${path.module}/flatcar/flatcar.yaml")
  vars = {
    hostname = each.key
    role = each.value.role
    server_token = random_id.k3s_server_token.hex
    agent_token = random_id.k3s_agent_token.hex
    zerotier_network_id = zerotier_network.zt_homelab.id
    zerotier_public_key = zerotier_identity.zerotier_node_identity[each.key].public_key
    zerotier_private_key = zerotier_identity.zerotier_node_identity[each.key].private_key
  }
}

data "ct_config" "flatcar_template" {
  for_each = var.nodes

  strict   = true
  content  = data.template_file.flatcar_template[each.key].rendered

  # snippets = [
  #   file("${path.module}/flatcar/zerotier.service"),
  # ]
}
