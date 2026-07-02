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

variable "tailscale_token" {
  sensitive = true
  type      = string
}

# SSH Keys
variable "gitlab_ssh_user_ids" {
  type    = set(string)
  default = ["90579"]
}

# Openstack Credentials
variable "openstack_auth_url" {
  type = string
}

variable "openstack_project_id" {
  type      = string
  sensitive = true
}

variable "openstack_username" {
  type = string
}

variable "openstack_password" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type        = string
  description = "Talos Kubernetes cluster name."
  default     = "dist-cc"
}

variable "talos_version" {
  type        = string
  description = "Talos Linux version used for Image Factory assets and machine config generation."
  default     = "v1.13.5"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version managed by the Talos provider."
  default     = "v1.36.0"
}

variable "talos_install_disk" {
  type        = string
  description = "Disk device Talos should install to."
  default     = "/dev/vda"
}

variable "talos_image_extensions" {
  type        = list(string)
  description = "Official Talos Image Factory system extensions to include."
  default = [
    "siderolabs/binfmt-misc",
    "siderolabs/fuse3",
    "siderolabs/nfsd",
    "siderolabs/qemu-guest-agent",
    "siderolabs/zerotier",
  ]
}

variable "nodes" {
  type = map(object({
    role   = string
    flavor = string
  }))

  validation {
    condition     = alltrue([for n in var.nodes : contains(["controlplane", "worker"], n.role)])
    error_message = "role must be a Talos node type: controlplane or worker."
  }

  validation {
    condition     = length([for n in var.nodes : n if n.role == "controlplane"]) > 0
    error_message = "at least one node must have the controlplane role."
  }

  default = {
    "ccdist-01" = {
      role   = "controlplane"
      flavor = "lg.2core"
    },
    "ccdist-02" = {
      role   = "worker"
      flavor = "lg.12core"
    }
  }
}
