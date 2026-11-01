variable "template_name" {
  type        = string
  description = "Name of VM template"
}

variable "description" {
  type        = string
  description = "VM template description"
}

variable "pve_node_name" {
  type        = string
  description = "Name of PVE node"
}

variable "tags" {
  type        = list(string)
  description = "VM Template tags"
  default     = null
}

variable "machine" {
  type        = string
  description = "VM Machine type"
  default     = "q35"
}

variable "bios" {
  type        = string
  description = "VM BIOS type"
  default     = "ovmf"
}

variable "scsi_hardware" {
  type        = string
  description = "Controller for disk"
  default     = "virtio-scsi-pci"
}

variable "cpu_cores" {
  type        = number
  description = "Number of VM CPU cores"
}

variable "memory_gb" {
  type        = number
  description = "Memory to assign to VM in GB"
}

variable "local_disk_datastore_id" {
  type        = string
  description = "ID of PVE storage object"
}

variable "iso_path" {
  type        = string
  description = "Path to VM image ISO (ex: nfs-iso:iso/metal-amd64.iso)"
}

variable "disk_size_gb" {
  type        = number
  description = "Disk space to assign to VM in GB"
}

variable "disk_cache" {
  type        = string
  description = "Caching option for disk"
  default     = null
}
