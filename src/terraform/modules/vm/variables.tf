variable "vm_name" {
  type        = string
  description = "Name of VM"
}

variable "pve_node_name" {
  type        = string
  default     = "pve"
  description = "Name of PVE node"
}

variable "template_id" {
  type        = string
  description = "VM Template ID to clone"
}

variable "cpu_cores" {
  type        = number
  default     = null
  description = "Number of VM CPU cores"
}

variable "memory_mb" {
  type        = number
  default     = null
  description = "Memory to assign to VM in MB"
}

variable "additional_disks" {
  description = "Additional disks to attach to VM"
  type = map(object({
    datastore_id = string
    interface    = string
    size_in_gb   = number
  }))
}

variable "disk_size_gb" {
  type        = number
  default     = null
  description = "Disk space to assign to VM in GB"
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "List of DNS servers to assign to VM"
}

variable "ipv4_addr" {
  type        = string
  description = "Static IP of VM"
}

variable "gateway_addr" {
  type        = string
  default     = "192.168.0.1"
  description = "IP of Gateway to set on VM"
}

variable "enable_qemu_agent" {
  type        = bool
  default     = null
  description = "Enable QEMU agent on VM"
}
