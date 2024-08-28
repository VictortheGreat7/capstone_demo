# This file contains the terraform code to create the necessary permissions for the AKS cluster

resource "azuread_group" "aks_admins" {
  display_name     = "aks-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    data.azuread_client_config.current.object_id, 
    var.my_user_object_id
  ]
}

resource "azurerm_role_assignment" "cluster_role_assignment" {
  scope                = azurerm_resource_group.aks_rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.capstone.identity[0].principal_id

  depends_on = [
    azurerm_kubernetes_cluster.capstone
  ]
}

# Assign Reader role to the AAD group for the Resource Group
resource "azurerm_role_assignment" "aks_admins_rg_reader" {
  scope                = azurerm_resource_group.aks_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.aks_admins.object_id

  depends_on = [
    azurerm_resource_group.aks_rg
  ]
}

# Assign Reader role to the AAD group for the Node Resource Group
resource "azurerm_role_assignment" "aks_admins_node_rg_reader" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.cluster_name}-nrg"
  role_definition_name = "Contributor"
  principal_id         = azuread_group.aks_admins.object_id

  depends_on = [
    azurerm_kubernetes_cluster.capstone
  ]
}

