variable "isos" {
  description = "ISO downloads for VMs"
  type = map(object({
    datastore_id  = optional(string, "nfs-iso")
    download_url  = string
    checksum      = optional(string)
    checksum_algo = optional(string)
  }))
}

variable "templates" {
  description = "VM Templates to create"
  type = map(object({
    cpu_cores    = number
    memory_mb    = number
    iso_name     = string
    disk_size_gb = number
  }))
}

variable "vms" {
  description = "VMs to create"
  type = map(object({
    template_name = string
    cpu_cores     = optional(number)
    memory_mb     = optional(number)
    additional_disks = optional(map(object({
      datastore_id = string
      interface    = string
      size_in_gb   = number
    })), {})

    dns_servers  = optional(list(string), [])
    ipv4_addr    = string
    gateway_addr = optional(string, "192.168.0.1")

    enable_qemu_agent = optional(bool, false)
  }))
}


