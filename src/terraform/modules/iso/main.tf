terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_download_file" "this" {
  content_type       = "iso"
  datastore_id       = var.datastore_id
  file_name          = var.file_name
  node_name          = var.pve_node_name
  url                = var.download_url
  checksum           = var.checksum
  checksum_algorithm = var.checksum_algo
}


