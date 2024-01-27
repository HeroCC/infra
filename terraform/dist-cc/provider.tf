terraform {
  required_providers {
    zerotier = {
      source  = "zerotier/zerotier"
      version = "~> 1.4"
    }
  }
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
