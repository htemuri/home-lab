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
  flux_sync_manifest = join("\n---\n", [
    yamlencode({
      apiVersion = "source.toolkit.fluxcd.io/v1"
      kind       = "GitRepository"
      metadata = {
        name      = "flux-system"
        namespace = "flux-system"
      }
      spec = {
        interval = "1m"
        url      = var.flux_repo_url
        ref = {
          branch = var.flux_repo_branch
        }
      }
    }),
    yamlencode({
      apiVersion = "kustomize.toolkit.fluxcd.io/v1"
      kind       = "Kustomization"
      metadata = {
        name      = "flux-system"
        namespace = "flux-system"
      }
      spec = {
        interval = "10m"
        path     = var.flux_path
        prune    = true
        sourceRef = {
          kind = "GitRepository"
          name = "flux-system"
        }
        decryption = {
          provider = "sops"
          secretRef = {
            name = "sops-age"
          }
        }
      }
    })
  ])
}
