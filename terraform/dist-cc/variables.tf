# Sensitive
variable "zerotier_central_token" {
  sensitive = true
  type      = string
}

variable "sops_age_key" {
  description = "Dedicated software age identity for Flux SOPS decryption. Stored in Terraform state and Talos machine configuration."
  sensitive   = true
  type        = string

  validation {
    condition     = can(regex("(?m)^AGE-SECRET-KEY-1[0-9A-Z]+", var.sops_age_key))
    error_message = "Provide a software age identity containing an AGE-SECRET-KEY-1 line."
  }
}

# Openstack Credentials
variable "openstack_cloud" {
  description = "OpenStack cloud name from clouds.yaml."
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Talos Kubernetes cluster name."
  default     = "dist-cc"
}

variable "talos_version" {
  type        = string
  description = "Talos Linux version used for Image Factory assets and machine config generation."
  default     = "v1.14.4"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version managed by the Talos provider."
  default     = "v1.37.1"
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
    # "siderolabs/qemu-guest-agent",
    "siderolabs/zerotier",
  ]
}

variable "nodes" {
  description = "Cluster nodes and their Kubernetes topology region and zone labels."
  type = map(object({
    role   = string
    flavor = string
    region = string
    zone   = string
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
      region = "CSAIL_Stata"
      zone   = "nova"
    },
    "ccdist-02" = {
      role   = "worker"
      flavor = "lg.12core"
      region = "CSAIL_Stata"
      zone   = "nova"
    },
    "ccdist-03" = {
      role   = "worker"
      flavor = "lg.4core"
      region = "CSAIL_Stata"
      zone   = "nova"
    }
  }
}
