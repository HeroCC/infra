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

data "openstack_networking_network_v2" "csail_float" {
  // Provided
  name = "FLOAT"
}

data "openstack_networking_network_v2" "csail_inet" {
  name = "inet"
}

resource "openstack_networking_router_v2" "csail_ccdist_router" {
  name           = "kube-router"
  admin_state_up = true
  external_network_id = data.openstack_networking_network_v2.csail_float.id
}

resource "openstack_networking_network_v2" "csail_ccdist_network" {
  name           = "kube"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "csail_ccdist_network_subnet" {
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.csail_ccdist_network.id
  cidr       = "192.168.199.0/24"
  dns_nameservers = ["128.30.2.25", "128.30.2.23", "128.30.2.24"]
  ip_version = 4
}

resource "openstack_networking_subnet_route_v2" "csail_ccdist_network_subnet_route" {
  subnet_id        = openstack_networking_subnet_v2.csail_ccdist_network_subnet.id
  destination_cidr = "169.254.169.254/32"
  // Fixes routing to the metadata service. Provided by `cloud-net` subnet of `inet`
  next_hop         = "128.52.160.134"
}

resource "openstack_networking_router_interface_v2" "attach_router_to_subnet" {
  router_id = openstack_networking_router_v2.csail_ccdist_router.id
  subnet_id = openstack_networking_subnet_v2.csail_ccdist_network_subnet.id
}

resource "openstack_networking_port_v2" "master_port" {
  name           = "master_port_1"
  network_id     = openstack_networking_network_v2.csail_ccdist_network.id
  admin_state_up = true

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.csail_ccdist_network_subnet.id
  }
}

# resource "openstack_networking_portforwarding_v2" "master_ssh_port_forward" {
#   internal_ip_address = openstack_networking_port_v2.master_port.all_fixed_ips[0]
#   internal_port_id = openstack_networking_port_v2.master_port.id

#   floatingip_id    = openstack_networking_port_v2.master_port.fixed_ip[0].id
#   external_port    = 22
#   internal_port    = 22
#   protocol         = "tcp"
# }