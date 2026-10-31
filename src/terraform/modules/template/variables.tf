variable "template_name" {
  type        = string
  description = "Name of VM template"
}

variable "cpu_cores" {
  type        = number
  description = "Number of VM CPU cores"
}

variable "memory_mb" {
  type        = number
  description = "Memory to assign to VM in MB"
}

variable "disk_size_gb" {
  type        = number
  description = "Disk space to assign to VM in GB"
}

variable "pve_node_name" {
  type        = string
  description = "Name of PVE node"
}

variable "local_disk_datastore_id" {
  type        = string
  description = "ID of PVE storage object"
}

variable "iso_path" {
  type        = string
  description = "Path to VM image ISO (ex: nfs-iso:iso/metal-amd64.iso)"
}
