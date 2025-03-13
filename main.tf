resource "azurerm_resource_group" "k8s-rg" {
  name     = "k8s"
  location = "South India"
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "k8s-sud"
  location            = azurerm_resource_group.k8s-rg.location
  resource_group_name = azurerm_resource_group.k8s-rg.name
  dns_prefix          = "k8s-sud-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_D4ds_v5"
  }

  identity {
    type = "SystemAssigned"
  }

}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  sensitive = true
}