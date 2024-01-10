terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.10.10:8006/api2/json"
}

# resource "proxmox_vm_qemu" "ubuntu-docker-host" {
#     name = "ubuntu-docker-host"
#     desc = "host docker containers"
#     pxe = true
#     agent = 0
#     automatic_reboot = true
#     balloon = 0
#     bios = "seabios"
#     boot = "order=scsi0;net0"
#     cores = 4
#     cpu = "host"
#     define_connection_info = true
#     force_create = false
#     kvm = true
#     memory = 6144


# }
