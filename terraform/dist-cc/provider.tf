terraform {
  required_providers {
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.8.1"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
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
  user_name   = var.openstack_username
  tenant_id   = var.openstack_project_id
  password    = var.openstack_password
  auth_url    = var.openstack_auth_url
}
