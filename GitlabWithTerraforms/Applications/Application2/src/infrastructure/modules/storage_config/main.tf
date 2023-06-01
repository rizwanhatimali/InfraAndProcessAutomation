data "azurerm_subscription" "current" {}
locals {
  containers = ["adf-operator"]
}

data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "identity" {
  name                = "id-${var.data_factory_name}"
  resource_group_name = var.resource_group_name
}


resource "azurerm_storage_container" "this" {
  for_each              = { for container in local.containers : container => container }
  name                  = each.key
  storage_account_name  = data.azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "data_factory_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.identity.principal_id
}


resource "azurerm_role_assignment" "role_assignment" {
  for_each             = { for user in var.user_roles : user.name => user }
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}