data "talos_image_factory_extensions_versions" "this" {
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

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controller" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  config_patches     = [local.machine_install]
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  config_patches     = [local.machine_install]
}

data "talos_client_configuration" "this" {
  depends_on = [proxmox_virtual_environment_vm.controller]

  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    for i, _ in proxmox_virtual_environment_vm.controller : "${cidrhost(var.controller_subnet, i + 1)}"
  ]
}


resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [proxmox_virtual_environment_vm.controller]
  count      = var.controller_count

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controller.machine_configuration
  node                        = cidrhost(var.controller_subnet, count.index + 1)
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_virtual_environment_vm.worker]
  count      = var.worker_count

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = cidrhost(var.worker_subnet, count.index + 1)
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.controller_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.controller_ip
}
