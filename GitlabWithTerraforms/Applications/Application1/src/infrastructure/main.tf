module "log_workspace" {
  source  = "git.eon-cds.de/emobility/log-workspace/azure"
  version = "0.1.8"

  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_name      = var.workspace_name
  sku                 = var.log_workspace_sku
  retention_in_days   = var.log_retention_in_days

}

module "key_vault" {
  source  = "git.eon-cds.de/emobility/key-vault/azure"
  version = "0.1.10"

  key_vault_name             = var.key_vault_name
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = module.log_workspace.log_analytics_workspace_id
  retention_days             = var.key_vault_deletion_retention_days
  log_retention_days         = var.log_retention_in_days
}

module "upload_storage_account" {
  source  = "git.eon-cds.de/emobility/storage-account/azure"
  version = "0.1.31"

  subscription_id                = var.subscription_id
  storage_account_name           = var.storage_account_name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  key_vault_id                   = module.key_vault.key_vault_id
  log_workspace_id               = module.log_workspace.log_analytics_workspace_id
  retention_days                 = var.storage_retention_days
  encryption_key_years_to_expire = var.storage_encryption_key_years_to_expire
  log_retention_days             = var.log_retention_in_days
  is_hns_enabled                 = true
}

module "upload_storage_configuration" {
  source = "./modules/upload_storage_config"

  subscription_id      = var.subscription_id
  storage_account_name = var.storage_account_name
  resource_group_name  = var.resource_group_name
  user_roles           = var.storage_roles

  depends_on = [module.upload_storage_account]
}

module "key_vault_configuration" {
  source = "./modules/key_vault_config"

  key_vault_name      = var.key_vault_name
  resource_group_name = var.resource_group_name
  user_roles          = var.key_vault_roles

  depends_on = [module.key_vault]
}