resource "random_id" "k3s_server_token" {
  byte_length = 35
}

resource "random_id" "k3s_agent_token" {
  byte_length = 32
}

data "template_file" "flatcar_server_template" {
  template = file("${path.module}/flatcar/flatcar.yaml")
  vars = {
    hostname = "probably-master"
    server_token = random_id.k3s_server_token.hex
    agent_token = random_id.k3s_agent_token.hex
  }
}

data "ct_config" "machine-ignitions" {
  strict   = true
  content  = data.template_file.flatcar_server_template.rendered
}