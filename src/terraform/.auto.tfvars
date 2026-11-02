isos = {
  "talos-os-v1_14_5.iso" = {
    download_url = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.14.5/nocloud-amd64.iso"
  }
}

templates = {
  "talos-controller" = {
    description = "Talos Linux controller node template VM"
    tags        = ["talos", "k8s"]
    cpu_cores   = 2
    memory_gb   = 4
    iso_name    = "talos-os-v1_14_5.iso"
    disk_cache  = "writethrough"
  }

  "talos-worker" = {
    description = "Talos Linux worker node template VM"
    tags        = ["talos", "k8s"]
    cpu_cores   = 4
    memory_gb   = 8
    iso_name    = "talos-os-v1_14_5.iso"
    disk_cache  = "writethrough"
  }
}

vms = {
  "olympus-controller" = {
    count            = 2
    template_name    = "talos-controller"
    dedicated_subnet = "192.168.96.0/29"
  }

  "olympus-worker" = {
    count            = 2
    template_name    = "talos-worker"
    dedicated_subnet = "192.168.96.16/28"
  }
}
