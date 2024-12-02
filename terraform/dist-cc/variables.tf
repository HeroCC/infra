# Sensitive
variable "zerotier_central_token" {
  sensitive = true
  type      = string
}

variable "edgevpn_token" {
  sensitive = true
  type      = string
}

variable "sops_gpg_key" {
  sensitive = true
  type      = string
}

variable "gitlab_token" {
  sensitive = true
  type      = string
}

# SSH Keys
variable "gitlab_ssh_user_ids" {
  type = set(string)
  default = [ "90579" ]
}

# Openstack Credentials
variable "openstack_auth_url" {
  type = string
}

variable "openstack_project_id" {
  type = string
  sensitive = true
}

variable "openstack_username" {
  type = string
}

variable "openstack_password" {
  type = string
  sensitive = true
}


variable "flatcar_version" {
  type        = string
  description = "The Flatcar version associated to the release channel"
  default     = "current"
}

variable "flatcar_release_channel" {
  type        = string
  description = "Flatcar Release channel"
  default     = "stable"

  validation {
    condition     = contains(["lts", "stable", "beta", "alpha"], var.flatcar_release_channel)
    error_message = "release_channel must be lts, stable, beta, or alpha."
  }
}