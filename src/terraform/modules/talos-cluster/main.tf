terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.12.0"
    }
  }
}

data "talos_image_factory_extensions_versions" "this" {
  # get the latest talos version
  talos_version = var.talos_version
  filters = {
    names = concat([
      "intel-ucode",
      "qemu-guest-agent",
    ], var.additional_talos_os_extensions)
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

resource "proxmox_download_file" "this" {
  depends_on   = [talos_image_factory_schematic.this]
  content_type = "iso"
  datastore_id = var.iso_datastore_id
  file_name    = "talos-os-${var.cluster_name}-${replace(var.talos_version, ".", "_")}.iso"
  node_name    = var.pve_node_name
  url          = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.iso"
}

# controller vm
resource "proxmox_virtual_environment_vm" "controller" {
  depends_on  = [proxmox_download_file.this]
  count       = var.controller_count
  name        = "${var.cluster_name}-controller-${format("%02s", count.index + 1)}"
  description = var.cluster_description
  node_name   = var.pve_node_name
  tags        = concat(["terraform", "talos-controller"], var.tags)

  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true
  scsi_hardware   = "virtio-scsi-pci"

  agent {
    enabled = true
    trim    = true
  }

  vga {
    type = "qxl"
  }

  cpu {
    type  = "host"
    cores = var.default_controller_cpu_cores
  }

  memory {
    dedicated = 1024 * var.default_controller_memory_gb
  }

  efi_disk {
    datastore_id = var.local_disk_datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = var.local_disk_datastore_id
    file_id      = proxmox_download_file.this.id
    interface    = "scsi0"
    ssd          = true
    file_format  = "raw"
    discard      = "on"
    size         = var.default_controller_disk_size_gb
    cache        = "writethrough"
  }

  dynamic "disk" {
    for_each = var.controller_additional_disks
    iterator = disk

    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size_in_gb
    }
  }

  initialization {
    dns {
      servers = concat([var.default_gateway], var.additional_dns_servers)
    }
    ip_config {
      ipv4 {
        address = "${cidrhost(var.controller_subnet, count.index + 1)}/16"
        gateway = var.default_gateway
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

# worker vm
resource "proxmox_virtual_environment_vm" "worker" {
  count       = var.worker_count
  name        = "${var.cluster_name}-worker-${format("%02s", count.index + 1)}"
  description = var.cluster_description
  node_name   = var.pve_node_name
  tags        = concat(["terraform", "talos-worker"], var.tags)

  machine         = "q35"
  bios            = "ovmf"
  started         = true
  stop_on_destroy = true
  scsi_hardware   = "virtio-scsi-pci"

  agent {
    enabled = true
    trim    = true
  }

  vga {
    type = "qxl"
  }

  cpu {
    type  = "host"
    cores = var.default_worker_cpu_cores
  }

  memory {
    dedicated = 1024 * var.default_worker_memory_gb
  }

  efi_disk {
    datastore_id = var.local_disk_datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = var.local_disk_datastore_id
    file_id      = proxmox_download_file.this.id
    interface    = "scsi0"
    ssd          = true
    file_format  = "raw"
    discard      = "on"
    size         = var.default_worker_disk_size_gb
    cache        = "writethrough"
  }

  dynamic "disk" {
    for_each = var.worker_additional_disks
    iterator = disk
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size_in_gb
    }
  }

  initialization {
    dns {
      servers = concat([var.default_gateway], var.additional_dns_servers)
    }
    ip_config {
      ipv4 {
        address = "${cidrhost(var.worker_subnet, count.index + 1)}/16"
        gateway = var.default_gateway
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

resource "talos_machine_secrets" "this" {}

#output "controller0_node_ip" {
#  value = proxmox_virtual_environment_vm.controller[0].ipv4_addresses
#}

data "talos_machine_configuration" "this" {
  cluster_name       = var.cluster_name
  machine_type       = "controlplane"
  cluster_endpoint   = "https://${cidrhost(var.controller_subnet, 1)}:6443"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = "v1.32.0"
}

# resource "talos_machine_configuration_apply" "this" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.this.machine_configuration
#   node                        = cidrhost(var.controller_subnet, 1)
#   config_patches = [
#     yamlencode({
#       machine = {
#         install = {
#           disk = "/dev/sda"
#         }
#       }
#     })
#   ]
# }


resource "talos_machine_configuration_apply" "this" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this.machine_configuration
  node                        = cidrhost(var.controller_subnet, 1)

  config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "UnattendedInstallConfig"

      provisioning = {
        diskSelector = {
          match = "disk.dev_path == \"/dev/sda\""
        }
      }
    })
  ]
}

#resource "talos_cluster" "this" {
#  depends_on           = [talos_machine_configuration_apply.this]
#  node                 = cidrhost(var.controller_subnet, 1)
#  client_configuration = talos_machine_secrets.this.client_configuration
#  kubernetes_version   = "v1.32.0"
#}
resource "talos_machine_bootstrap" "this" {
  depends_on = [
    talos_machine_configuration_apply.this
  ]
  node                 = "10.5.0.2"
  client_configuration = talos_machine_secrets.this.client_configuration
}
resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = cidrhost(var.controller_subnet, 1)
  depends_on           = [talos_machine_bootstrap.this]
}
