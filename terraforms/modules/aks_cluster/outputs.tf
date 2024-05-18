output "aks_id" {
  value = azurerm_kubernetes_cluster.MOD-AKS.id
}

output "aks_principal_id" {
  value = azurerm_kubernetes_cluster.MOD-AKS.kubelet_identity[0].object_id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.MOD-AKS.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.MOD-AKS.node_resource_group
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.MOD-AKS.kube_config_raw
}

/*resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.MOD-AKS]
  filename = "kubeconfig"
  content = azurerm_kubernetes_cluster.MOD-AKS.kube_config_raw
}*/