variable "pve_api_token" {
  type        = string
  description = "PVE API token"
  sensitive   = true
}

variable "pve_ssh_password" {
  type        = string
  description = "PVE SSH password"
  sensitive   = true
}

variable "node_name" {
  type        = string
  description = "Name of PVE node"
}

variable "datastore_id" {
  type        = string
  description = "ID of PVE storage object"
}


