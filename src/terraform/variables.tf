variable "templates" {
  description = "VM Templates to create"
  type = map(object({
    cpu_cores    = number
    memory_mb    = number
    iso_path     = string
    disk_size_gb = number
  }))
}


