module "log_workspace" {
  source  = "git.eon-cds.de/emobility/log-workspace/azure"
  version = "0.1.6"

  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_name      = var.workspace_name
  sku                 = var.log_workspace_sku
  retention_in_days   = var.log_retention_in_days

}

module "key_vault" {
  source  = "git.eon-cds.de/emobility/key-vault/azure"
  version = "0.1.8"

  key_vault_name               = var.key_vault_name
  resource_group_name          = var.resource_group_name
  log_analytics_workspace_name = var.workspace_name
  retention_days               = var.key_vault_deletion_retention_days
  log_retention_days           = var.log_retention_in_days
  depends_on                   = [module.log_workspace]
}

module "df_storage_account" {
  source  = "git.eon-cds.de/emobility/storage-account/azure"
  version = "0.1.28"

  subscription_id                = var.subscription_id
  storage_account_name           = var.storage_account_name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  key_vault_name                 = var.key_vault_name
  log_analytics_workspace_name   = var.workspace_name
  retention_days                 = var.storage_retention_days
  encryption_key_years_to_expire = var.storage_encryption_key_years_to_expire
  log_retention_days             = var.log_retention_in_days
  is_hns_enabled                 = true

  depends_on = [module.key_vault]
}

module "data_factory" {
  source                         = "git.eon-cds.de/emobility/data-factory/azure"
  version                        = "0.1.11"
  subscription_id                = var.subscription_id
  resource_group_name            = var.resource_group_name
  location                       = var.location
  data_factory_name              = var.data_factory_name
  key_vault_name                 = var.key_vault_name
  log_retention_days             = var.log_retention_in_days
  encryption_key_years_to_expire = var.storage_encryption_key_years_to_expire
  log_analytics_workspace_name   = var.workspace_name
  organization                   = "EON-Drive-eMobility"
  project_name                   = "Operator-Integration"
  repository_name                = "Operator-DataFactory"
  collaboration_branch_name      = "main"
  root_folder                    = "/"
}

module "operators_mongo" {
  source  = "git.eon-cds.de/emobility/mongodb/azure"
  version = "0.1.6"

  resource_group_name          = var.resource_group_name
  log_analytics_workspace_name = var.workspace_name
  log_retention_days           = var.log_retention_in_days
  collections                  = []
  mongodb_database_name        = var.mongodb_database_name
  cosmosdb_max_throughput      = var.cosmosdb_max_throughput
  cosmosdb_account_name        = var.cosmosdb_account_name
  failover_location            = var.failover_location
}

resource "azurerm_cosmosdb_mongo_collection" "coll" {
  for_each            = { for collection in var.mongo_collections : collection.name => collection }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = var.cosmosdb_account_name
  database_name       = var.mongodb_database_name

  default_ttl_seconds = "777"
  shard_key           = each.value.shard_key
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }

  lifecycle {
    ignore_changes = [index]
  }

  depends_on = [module.operators_mongo]

}

module "operators_postgres" {
  source  = "git.eon-cds.de/emobility/postgresql-cluster/azure"
  version = "0.1.6"

  resource_group_name          = var.resource_group_name
  cluster_name                 = var.cluster_name
  coordinator_vcore_count      = var.coordinator_vcore_count
  node_count                   = var.node_count
  log_analytics_workspace_name = var.workspace_name
  log_retention_days           = var.log_retention_in_days
}


module "storage_configuration" {
  source = "./modules/storage_config"

  subscription_id      = var.subscription_id
  storage_account_name = var.storage_account_name
  resource_group_name  = var.resource_group_name
  user_roles           = var.storage_roles
  data_factory_name    = var.data_factory_name

  depends_on = [module.df_storage_account]
}

module "key_vault_configuration" {
  source = "./modules/key_vault_config"

  key_vault_name      = var.key_vault_name
  resource_group_name = var.resource_group_name
  user_roles          = var.key_vault_roles

  depends_on = [module.key_vault]
}

module "postgresql_configure" {
  source = "./modules/operators_postgresql"

  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
  key_vault_name      = var.key_vault_name
  admin               = module.operators_postgres.admin_password
}