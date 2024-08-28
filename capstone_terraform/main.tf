# This file contains the terraform code to create the AKS cluster.

resource "azurerm_resource_group" "aks_rg" {
  name     = var.rg_name
  location = var.region
}

resource "azurerm_kubernetes_cluster" "capstone" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  dns_prefix          = "${var.rg_name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.default_version
  node_resource_group = "${var.cluster_name}-nrg"

  api_server_access_profile {
    authorized_ip_ranges = var.allowed_source_addresses
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.aks_admins.id]
  }

  default_node_pool {
    name                = "defaultpool"
    vm_size             = "Standard_D4S_v3"
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 1
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    max_pods            = 110
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "test"
      "nodepoolos"    = "linux"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "test"
      "nodepoolos"    = "linux"
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "test"
  }
}