terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "= 0.12.0-alpha.5"
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
  user_name = var.openstack_username
  tenant_id = var.openstack_project_id
  password  = var.openstack_password
  auth_url  = var.openstack_auth_url
}
