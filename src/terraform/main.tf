terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.10.10:8006/"
  api_token = var.pve_api_token
  insecure  = true

  ssh {
    agent       = true
    username    = "root"
    root_ticket = true
    password    = var.pve_ssh_password
  }
}

resource "proxmox_virtual_environment_vm" "talos_template" {
  name      = "talos-template"
  node_name = var.node_name

  template = true
  started  = false

  machine     = "q35"
  bios        = "ovmf"
  description = "Managed by Terraform"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  efi_disk {
    datastore_id = var.datastore_id
    type         = "4m"
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = "nfs-iso:iso/metal-amd64.iso"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    #user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

}
