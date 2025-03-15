terraform {
backend "azurerm" {
  resource_group_name  = "infra-jenkins-cicd"
  storage_account_name = "azbackendbucket"
  container_name       = "backend"
  key                  = "terraform.tfstate"
}  
}
 provider "azurerm" {
  features {}
  subscription_id = "a95dbe9e-bf88-4327-88b8-f85c96e18436"
  #tenant_id = "6af5992f-c8b9-4f47-ba6e-f795ec682a52"
  #client_id = "533c0e52-4b6a-4b8c-8167-7f6c66d9742a"
  #client_secret = "rgy8Q~xLrwN1ptmTRTDJkRvTIXgApZ9ZPLb37cG6"
}

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
