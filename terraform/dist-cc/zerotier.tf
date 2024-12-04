resource "zerotier_network" "zt_homelab" {
  name = "CCloud"

  assign_ipv6 {
    rfc4193 = true
  }

  assignment_pool {
    start = "10.242.0.100"
    end   = "10.242.0.250"
  }

  route {
    target = "10.242.0.0/24"
  }
}

resource "zerotier_identity" "zerotier_node_identity" {
  for_each = var.nodes
}

resource "zerotier_member" "zerotier_node_network_membership" {
  for_each = var.nodes
  name = each.key
  network_id = zerotier_network.zt_homelab.id
  member_id = zerotier_identity.zerotier_node_identity[each.key].id
}