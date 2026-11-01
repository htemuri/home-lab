variable "pve_node_name" {
  type        = string
  default     = "pve"
  description = "Name of PVE node"
}

variable "datastore_id" {
  type        = string
  description = "ID of Datastore for ISO"
}

variable "file_name" {
  type        = string
  description = "Destination ISO file name"
}

variable "download_url" {
  type        = string
  description = "URL to download ISO file"
}

variable "checksum" {
  type        = string
  default     = null
  description = "Checksum of file download"
}

variable "checksum_algo" {
  type        = string
  default     = null
  description = "Algorithm of the file download checksum"
}
