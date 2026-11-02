terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.template_name
  description = var.description
  node_name   = var.pve_node_name
  tags        = concat(["terraform", "template"], var.tags)

  machine         = var.machine
  bios            = var.bios
  template        = true
  started         = false
  stop_on_destroy = true
  scsi_hardware   = var.scsi_hardware

  agent {
    enabled = true
    trim    = true
  }

  vga {
    type = "qxl"
  }

  cpu {
    type  = "host"
    cores = var.cpu_cores
  }

  memory {
    dedicated = 1024 * var.memory_gb
  }

  efi_disk {
    datastore_id = var.local_disk_datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = var.local_disk_datastore_id
    file_id      = var.iso_path
    interface    = "scsi0"
    ssd          = true
    file_format  = "raw"
    discard      = "on"
    size         = var.disk_size_gb

    cache = var.disk_cache
  }

  initialization {
    ip_config {
      ipv4 {

        address = "dhcp"
      }
    }
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = "vmbr0"
  }
}
