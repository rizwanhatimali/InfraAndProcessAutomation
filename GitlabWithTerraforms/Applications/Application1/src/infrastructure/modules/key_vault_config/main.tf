
data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

locals {
  key_vault_id = data.azurerm_key_vault.this.id
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each             = { for user in var.user_roles : user.name => user }
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}