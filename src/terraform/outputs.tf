output "cluster_configs" {
  value = {
    for name, cluster in module.talos-cluster : name => {
      talosconfig = cluster.talosconfig
      kubeconfig  = cluster.kubeconfig
    }
  }
  sensitive = true
}
