templates = {
  "talos-controller" = {
    cpu_cores    = 2
    memory_mb    = 4096
    disk_size_gb = 20
    iso_path     = "nfs-iso:iso/metal-amd64.iso"
  }

  "talos-worker" = {
    cpu_cores    = 4
    memory_mb    = 8192
    disk_size_gb = 20
    iso_path     = "nfs-iso:iso/metal-amd64.iso"
  }
}

vms = {
  "olympus-controller-01" = {
    template_name = "talos-controller"
    ipv4_addr     = "192.168.96.1"
  }

  "olympus-controller-02" = {
    template_name = "talos-controller"
    ipv4_addr     = "192.168.96.2"
  }

  "olympus-worker-01" = {
    template_name = "talos-worker"
    ipv4_addr     = "192.168.96.6"
  }

  "olympus-worker-02" = {
    template_name = "talos-worker"
    ipv4_addr     = "192.168.96.7"
  }
}
