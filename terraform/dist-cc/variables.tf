# Sensitive
variable "zerotier_central_token" {
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
