locals {
  base_id      = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers"
  cluster_id   = "${local.base_id}/Microsoft.DBforPostgreSQL/serverGroupsv2/${var.cluster_name}"
  key_vault_id = "${local.base_id}/Microsoft.KeyVault/vaults/${var.key_vault_name}"
}

resource "random_password" "password" {
  length      = 128
  lower       = true
  upper       = true
  numeric     = true
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_cosmosdb_postgresql_role" "empdata" {
  name       = "empdata"
  cluster_id = local.cluster_id
  password   = random_password.password.result
}

resource "azurerm_key_vault_secret" "empdata_password" {
  key_vault_id = local.key_vault_id
  name         = "cospos-emobility-operators-empdata-password"
  value        = random_password.password.result
}

resource "azurerm_key_vault_secret" "admin_password" {
  key_vault_id = local.key_vault_id
  name         = "cospos-emobility-operators-password"
  value        = var.admin
}