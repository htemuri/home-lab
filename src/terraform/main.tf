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
