terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = var.pve_node_name

  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = var.enable_qemu_agent
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  dynamic "disk" {
    for_each = var.additional_disks
    iterator = disk

    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size_in_gb
    }
  }

  initialization {
    dns {
      servers = concat([var.gateway_addr], var.dns_servers)
    }
    ip_config {
      ipv4 {
        address = var.ipv4_addr
        gateway = var.gateway_addr
      }
    }

  }

  network_device {
    bridge = "vmbr0"
  }

}
