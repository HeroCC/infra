terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "= 0.12.0"
    }
    zerotier = {
      source  = "zerotier/zerotier"
      version = "~> 1.4"
    }
  }
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}

provider "openstack" {
  cloud = var.openstack_cloud
}
