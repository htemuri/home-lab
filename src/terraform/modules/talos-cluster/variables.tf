variable "cluster_name" {
  type        = string
  description = "Name of cluster"
}

variable "cluster_description" {
  type        = string
  description = "Cluster description"
  default     = null
}

variable "pve_node_name" {
  type        = string
  description = "Name of PVE node"
}

variable "tags" {
  type        = list(string)
  description = "Cluster tags"
  default     = []
}

variable "talos_version" {
  type        = string
  description = "Which release of Talos OS for each node"
  default     = "v1.14.5"
}

variable "additional_talos_os_extensions" {
  type        = list(string)
  description = "Additional talos factory extensions to add to OS image"
  default     = []
}

variable "iso_datastore_id" {
  type        = string
  description = "Path to VM image ISO datastore (ex: nfs-iso)"
  default     = "nfs-iso"
}

variable "local_disk_datastore_id" {
  type        = string
  description = "ID of PVE storage object"
}

variable "default_gateway" {
  type        = string
  description = "IP address of default gateway"
}

variable "additional_dns_servers" {
  type        = list(string)
  default     = []
  description = "List of additional DNS servers to add besides the default gateway"
}

variable "controller_count" {
  type        = number
  description = "Number of talos controller nodes in cluster"
}

variable "default_controller_cpu_cores" {
  type        = number
  description = "Number of VM CPU cores per controller node"
}

variable "default_controller_memory_gb" {
  type        = number
  description = "Memory in GB to assign per controller VM"
}

variable "default_controller_disk_size_gb" {
  type        = number
  description = "Disk space to assign to VM in GB"
}

variable "controller_additional_disks" {
  description = "Additional disks to attach to controller VMs"
  type = map(object({
    datastore_id = string
    interface    = string
    size_in_gb   = number
  }))
}

variable "controller_subnet" {
  type        = string
  description = "Subnet to assign controller vm static IPs within"
}

variable "worker_count" {
  type        = number
  description = "Number of talos worker nodes in cluster"
}

variable "default_worker_cpu_cores" {
  type        = number
  description = "Number of VM CPU cores per worker node"
}

variable "default_worker_memory_gb" {
  type        = number
  description = "Memory in GB to assign per worker VM"
}

variable "default_worker_disk_size_gb" {
  type        = number
  description = "Disk space to assign to VM in GB"
}

variable "worker_additional_disks" {
  description = "Additional disks to attach to worker VMs"
  type = map(object({
    datastore_id = string
    interface    = string
    size_in_gb   = number
  }))
}

variable "worker_subnet" {
  type        = string
  description = "Subnet to assign worker vm static IPs within"
}
