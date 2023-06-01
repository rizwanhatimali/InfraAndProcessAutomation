variable "subscription_id" {
  type        = string
  default     = "173ca103-a555-45e3-b5e9-58d11c4f2f72"
  description = "The id of the subscription to deploy to"
}

variable "resource_group_name" {
  type        = string
  default     = "RG-eMobility-Operator-Integration-Dev"
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location to create the resources in"
}

variable "workspace_name" {
  type        = string
  default     = "Log-eMobility-Operator-Dev"
  description = "The name of the log analytics workspace"
}

variable "log_workspace_sku" {
  type        = string
  default     = "PerGB2018"
  description = "The version of the log anlaytics workspace to create"
}

variable "log_retention_in_days" {
  type        = number
  default     = 90
  description = "The number of days to keep the logs"
}

variable "key_vault_name" {
  type        = string
  default     = "KV-eMob-Operator-Dev"
  description = "The name of the  key vault"
}

variable "key_vault_deletion_retention_days" {
  type        = number
  description = "The number of days to retain deleted keys, secrets and certificates"
  default     = 90
}

variable "key_vault_roles" {
  type = list(object({
    name                 = string
    principal_id         = string
    principal_name       = string
    role_definition_name = string
  }))
  description = "The users and the roles that need to be applied to the key vault"
  default = [
    {
      name                 = "Reader"
      principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
      principal_name       = "eMobility Operators Key Vault Reader"
      role_definition_name = "Key Vault Reader"
    },
    {
      name                 = "Reader-Secrets"
      principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
      principal_name       = "eMobility Operators Key Vault Reader"
      role_definition_name = "Key Vault Secrets User"
    },
    {
      name                 = "Reader-Keys"
      principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
      principal_name       = "eMobility Operators Key Vault Reader"
      role_definition_name = "Key Vault Crypto User"
    },
    {
      name                 = "Admin"
      principal_id         = "cab2088c-229d-4f44-acbb-f13770a4aefb"
      principal_name       = "eMobility Operators Key Vault Manager"
      role_definition_name = "Key Vault Administrator"
    }
  ]
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
  default     = "stadfoperatordev"
}

variable "storage_retention_days" {
  type        = number
  description = "The number of days to retain deleted items in the storage account"
  default     = 30
}

variable "storage_encryption_key_years_to_expire" {
  type        = number
  description = "The number of years for the encryption key to expire."
  default     = 3
}

variable "storage_roles" {
  type = list(object({
    name                 = string
    principal_id         = string
    principal_name       = string
    role_definition_name = string
  }))
  description = "The users and the roles that need to be applied to the storage account"
  default = [
    {
      name                 = "Testers"
      principal_id         = "adf873af-0ca8-4cd4-a335-b00b936d99d8"
      principal_name       = "eMobility Operators Testers"
      role_definition_name = "Storage Blob Data Contributor"
    },
    {
      name                 = "Developers"
      principal_id         = "2ad0a2ff-1efd-49f8-84e1-bb595f398555"
      principal_name       = "eMobility Operators Developers"
      role_definition_name = "Storage Blob Data Contributor"
    },
    {
      name                 = "Admin"
      principal_id         = "56124967-5587-4c27-8f9f-25cc3f51a75c"
      principal_name       = "eMobility Operators Admin"
      role_definition_name = "Storage Blob Data Owner"
    }
  ]
}

variable "data_factory_name" {
  type        = string
  default     = "ADF-Operator-Dev"
  description = "The name of the Azure Data Factory."
}

variable "failover_location" {
  type        = string
  default     = "westeurope"
  description = "The secondary geographic location for the failover of the mongo database"
}

variable "cosmosdb_account_name" {
  type        = string
  default     = "cosmon-operators-dev"
  description = "The name of the cosmos account into which the database will be created"
}
variable "mongodb_database_name" {
  type        = string
  default     = "Virta"
  description = "The name of the database to create"
}

variable "cosmosdb_max_throughput" {
  type    = number
  default = 400
}

variable "mongo_collections" {
  type = list(object({
    name      = string
    shard_key = string
    indexes = list(object({
      name   = string
      keys   = list(string)
      unique = bool
    }))
  }))
  default = []
}

variable "cluster_name" {
  type        = string
  description = "The name of the Azure Cosmos DB for PostgreSQL cluster"
  default     = "cospos-emobility-operators-dev"
}

variable "coordinator_vcore_count" {
  type        = number
  description = "The number of v cores that the clustomer coordinator should have"
  default     = 2
}

variable "node_count" {
  type        = number
  description = "The worker node count of the Azure Cosmos DB for PostgreSQL Cluster. Possible value is between 0 and 20 except 1"
  default     = 0
}

