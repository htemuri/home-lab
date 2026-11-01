isos = {
  "talos-os-v1_14_5.iso" = {
    download_url  = "https://github.com/siderolabs/talos/releases/download/v1.14.5/metal-amd64.iso"
    checksum      = "1505108d78e6260e2a586ced144b928478d70e2424b45f890f5f18a82d30f754"
    checksum_algo = "sha256"
  }
}

templates = {
  "talos-controller" = {
    cpu_cores    = 2
    memory_mb    = 4096
    disk_size_gb = 20
    iso_name     = "talos-os-v1_14_5.iso"
  }

  "talos-worker" = {
    cpu_cores    = 4
    memory_mb    = 8192
    disk_size_gb = 20
    iso_name     = "talos-os-v1_14_5.iso"
  }
}

vms = {
  "olympus-controller-01" = {
    template_name = "talos-controller"
    ipv4_addr     = "192.168.96.1/16"
  }

  "olympus-controller-02" = {
    template_name = "talos-controller"
    ipv4_addr     = "192.168.96.2/16"
  }

  "olympus-worker-01" = {
    template_name = "talos-worker"
    ipv4_addr     = "192.168.96.6/16"
  }

  "olympus-worker-02" = {
    template_name = "talos-worker"
    ipv4_addr     = "192.168.96.7/16"
  }
}
