locals {
  vm_instances = {
    for vm in flatten([
      for group_name, group in var.vms : [
        for i in range(group.count) : {
          key        = "${group_name}-${format("%02d", i + 1)}"
          config     = group
          host_index = i + 1
        }
      ]
    ]) : vm.key => vm
  }
}
