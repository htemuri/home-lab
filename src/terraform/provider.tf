provider "proxmox" {
  endpoint = "https://192.168.10.10:8006/"
  insecure = true

  ssh {
    agent       = true
    root_ticket = true
  }
}
