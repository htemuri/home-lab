locals {
  controller_ip    = cidrhost(var.controller_subnet, 1)
  cluster_endpoint = "https://${local.controller_ip}:6443"
  install_disk     = "/dev/sda"
  machine_install = yamlencode({
    apiVersion = "v1alpha1"
    kind       = "UnattendedInstallConfig"
    installer = {
      image = "factory.talos.dev/nocloud-installer/${talos_image_factory_schematic.this.id}:${var.talos_version}"
    }
    provisioning = {
      diskSelector = {
        match = "disk.dev_path == \"${local.install_disk}\""
      }
    }
  })
}
