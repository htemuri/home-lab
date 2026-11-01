module "iso" {
  source   = "./modules/iso"
  for_each = var.isos

  file_name     = each.key
  pve_node_name = "pve"
  datastore_id  = each.value.datastore_id
  download_url  = each.value.download_url
  checksum      = each.value.checksum
  checksum_algo = each.value.checksum_algo
}

module "template" {
  source   = "./modules/template"
  for_each = var.templates

  template_name = each.key
  pve_node_name = "pve"
  description   = each.value.description
  tags          = each.value.tags

  machine       = each.value.machine
  bios          = each.value.bios
  scsi_hardware = each.value.scsi_hardware

  cpu_cores = each.value.cpu_cores
  memory_gb = each.value.memory_gb
  iso_path  = module.iso[each.value.iso_name].id

  local_disk_datastore_id = each.value.local_disk_datastore_id
  disk_size_gb            = each.value.disk_size_gb
  disk_cache              = each.value.disk_cache
}

module "vm" {
  source   = "./modules/vm"
  for_each = local.vm_instances

  vm_name           = each.key
  template_id       = module.template[each.value.config.template_name].id
  cpu_cores         = each.value.config.cpu_cores
  memory_gb         = each.value.config.memory_gb
  additional_disks  = each.value.config.additional_disks
  dns_servers       = each.value.config.dns_servers
  gateway_addr      = each.value.config.gateway_addr
  enable_qemu_agent = each.value.config.enable_qemu_agent

  ipv4_addr = "${cidrhost(
    each.value.config.dedicated_subnet,
    each.value.host_index
  )}/16"
}
#
#
#
#resource "proxmox_virtual_environment_vm" "test" {
#  name      = "test-vm"
#  node_name = "pve"
#
#  started = false
#
#  machine     = "q35"
#  bios        = "ovmf"
#  description = "Managed by Terraform"
#
#  agent {
#    enabled = true
#    trim    = true
#  }
#
#  vga {
#    type = "qxl"
#  }
#
#  cpu {
#    type  = "host"
#    cores = 2
#  }
#
#  memory {
#    dedicated = 4096
#  }
#
#  disk {
#    datastore_id = "local-lvm"
#    file_id      = "nfs-iso:iso/metal-amd64.iso"
#    interface    = "scsi0"
#    iothread     = true
#    ssd          = true
#    file_format  = "raw"
#    discard      = "on"
#    size         = 40
#  }
#
#  efi_disk {
#    datastore_id = "local-lvm"
#    file_format  = "raw"
#    type         = "4m"
#  }
#
#  initialization {
#    ip_config {
#      ipv4 {
#        address = "dhcp"
#        #address = "192.168.96.12/16"
#        #gateway = "192.168.0.1"
#      }
#    }
#  }
#  stop_on_destroy = true
#  #  scsi_hardware   = "virtio-scsi-single"
#  operating_system {
#    type = "l26"
#  }
#  network_device {
#    bridge = "vmbr0"
#  }
#  tpm_state {
#    version = "v2.0"
#  }
#
#}
#
