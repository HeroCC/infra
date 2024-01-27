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