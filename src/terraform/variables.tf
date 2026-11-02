# variable "isos" {
#   description = "ISO downloads for VMs"
#   type = map(object({
#     datastore_id  = optional(string, "nfs-iso")
#     download_url  = string
#     checksum      = optional(string)
#     checksum_algo = optional(string)
#   }))
# }

variable "clusters" {
  description = "Talos clusters to create"
  type = map(object({
    description             = optional(string)
    pve_node_name           = optional(string, "pve")
    tags                    = optional(list(string))
    talos_version           = optional(string, "v1.14.5")
    local_disk_datastore_id = optional(string, "local-lvm")
    controller_count        = optional(number, 1)
    controller_cpu_cores    = optional(number, 2)
    controller_memory_gb    = optional(number, 4)
    controller_disk_gb      = optional(number, 20)
    controller_additional_disks = optional(map(object({
      datastore_id = string
      interface    = string
      size_in_gb   = number
    })), {})
    controller_subnet = string
    worker_count      = optional(number, 1)
    worker_cpu_cores  = optional(number, 4)
    worker_memory_gb  = optional(number, 8)
    worker_disk_gb    = optional(number, 20)
    worker_additional_disks = optional(map(object({
      datastore_id = string
      interface    = string
      size_in_gb   = number
    })), {})
    worker_subnet = string
  }))
}


# variable "templates" {
#   description = "VM Templates to create"
#   type = map(object({
#     description = string
#     tags        = optional(list(string))
# 
#     machine       = optional(string, "q35")
#     bios          = optional(string, "ovmf")
#     scsi_hardware = optional(string, "virtio-scsi-pci")
# 
#     cpu_cores = number
#     memory_gb = number
#     iso_name  = string
# 
#     local_disk_datastore_id = optional(string, "local-lvm")
#     disk_cache              = optional(string)
#     disk_size_gb            = optional(number, 20)
#   }))
# }
# 
# variable "vms" {
#   description = "VMs to create"
#   type = map(object({
#     count         = optional(number, 1)
#     tags          = optional(list(string), [])
#     template_name = string
#     cpu_cores     = optional(number)
#     memory_gb     = optional(number)
#     additional_disks = optional(map(object({
#       datastore_id = string
#       interface    = string
#       size_in_gb   = number
#     })), {})
# 
#     dns_servers      = optional(list(string), [])
#     dedicated_subnet = string
#     gateway_addr     = optional(string, "192.168.0.1")
# 
#     enable_qemu_agent = optional(bool, false)
#   }))
# }
# 
# 
