
### IP Ranges for the network

| **Name**           | **CIDR**         | **IP Range**                  | **Total addresses** | **Use case**                         |
|:------------------ | ---------------- | ----------------------------- | ------------------- | ------------------------------------ |
| Total              | 192.168.0.0/16   | 192.168.0.0 - 192.168.255.255 | 65,536              | Total Address space                  |
| DHCP           | 192.168.0.0/24   | 192.168.0.0-192.168.0.255     | 256                 | DHCP, router, desktop, phone, laptop |
| Secure             | 192.168.10.0/24  | 192.168.10.0-192.168.10.255   | 256                 | Dell servers                         |
| Virtual Appliances | 192.168.100.0/20 | 192.168.100.0-192.168.115.255 | 4,096               | VMs, Container, and others           |
| VPN                | 192.168.200.0/28 | 192.168.200.0-192.168.200.15  | 16                  | VPN Tunnel space for Wireguard users |
### Key Appliances:
| **Name** | **Subnet** | **IP Address** | **FQDN** | **Port** | **Protocol** |
| ---- | ---- | ---- | ---- | ---- | ---- |
| LAN (RouterOS) | DHCP | 192.168.0.0 | gateway.lab | 80 | TCP |
| DNS | Secure | 192.168.10.100 | dns.lab | 53 | TCP |
| R730_01 | Secure | 192.168.10.1 | nimbus.lab | 80 | TCP |
| R730XD | Secure | 192.168.10.2 | memnous.lab | 80 | TCP |
| R730_02 | Secure | 192.168.10.3 | aurora.lab | 80 | TCP |
| NFS | Virtual Appliances | 192.168.100.0 | archive.lab | 80 | TCP |
| Proxmox_01 | Secure | 192.168.10.10 | olympus.lab | 8006 | TCP |
| Proxmox_02 | Secure | 192.168.10.11 | aether.lab | 8006 | TCP |
