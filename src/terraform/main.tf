module "template" {
  source   = "./modules/template"
  for_each = var.templates

  template_name           = each.key
  pve_node_name           = "pve"
  local_disk_datastore_id = "local-lvm"
  cpu_cores               = each.value.cpu_cores
  memory_mb               = each.value.memory_mb
  iso_path                = each.value.iso_path
  disk_size_gb            = each.value.disk_size_gb
}

module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  vm_name           = each.key
  template_id       = module.template[each.value.template_name].template_id
  cpu_cores         = each.value.cpu_cores
  memory_mb         = each.value.memory_mb
  additional_disks  = each.value.additional_disks
  dns_servers       = each.value.dns_servers
  ipv4_addr         = each.value.ipv4_addr
  gateway_addr      = each.value.gateway_addr
  enable_qemu_agent = each.value.enable_qemu_agent
}
