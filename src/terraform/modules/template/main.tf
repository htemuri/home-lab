terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.template_name
  node_name = var.pve_node_name

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  efi_disk {
    datastore_id = var.local_disk_datastore_id
    type         = "4m"
  }

  disk {
    datastore_id = var.local_disk_datastore_id
    file_id      = var.iso_path
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size_gb
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

  }

  network_device {
    bridge = "vmbr0"
  }

}
