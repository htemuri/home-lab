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
    names = [
      "intel-ucode",
      "qemu-guest-agent",
    ]
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
  name        = "${var.cluster_name}-controller-${format("%02s", count.index)}"
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
        address = "${cidrhost(var.controller_subnet, count.index)}/16"
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
  name        = "${var.cluster_name}-worker-${format("%02s", count.index)}"
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
        address = "${cidrhost(var.worker_subnet, count.index)}/16"
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
