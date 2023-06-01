variable "subscription_id" {
  type        = string
  default     = "173ca103-a555-45e3-b5e9-58d11c4f2f72"
  description = "The id of the subscription to deploy to"
}

variable "resource_group_name" {
  type        = string
  default     = "RG-eMobility-Firmware-QAS"
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location to create the resources in"
}

variable "workspace_name" {
  type        = string
  default     = "LOG-eMobility-Firmware-Qas"
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
  default     = "KV-Firmware-Qas"
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
      principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
      principal_name       = "eMobility Firmware Key Vault Reader"
      role_definition_name = "Key Vault Reader"
    },
    {
      name                 = "Reader-Secrets"
      principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
      principal_name       = "eMobility Firmware Key Vault Reader"
      role_definition_name = "Key Vault Secrets User"
    },
    {
      name                 = "Reader-Keys"
      principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
      principal_name       = "eMobility Firmware Key Vault Reader"
      role_definition_name = "Key Vault Crypto User"
    },
    {
      name                 = "Admin"
      principal_id         = "86fe273f-c8b8-4d83-8876-dc57676c53f5"
      principal_name       = "eMobility Firmware Key Vault Manager"
      role_definition_name = "Key Vault Administrator"
    }
  ]
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
  default     = "stfirmwareqas"
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
      name                 = "User"
      principal_id         = "b879cec6-94e6-4965-a6cc-5c9f256bca13"
      principal_name       = "eMobility Firmware Upload"
      role_definition_name = "Storage Blob Data Contributor"
    },
    {
      name                 = "Testers"
      principal_id         = "bf2b25df-94ff-4b14-9f26-f2bfbc006c45"
      principal_name       = "eMobility Firmware Testers"
      role_definition_name = "Storage Blob Data Contributor"
    },
    {
      name                 = "Developers"
      principal_id         = "d03023d5-b228-49f3-b307-308368df6139"
      principal_name       = "eMobility Firmware Developers"
      role_definition_name = "Storage Blob Data Contributor"
    },
    {
      name                 = "Admin"
      principal_id         = "0786f372-8837-4e64-a3de-0788244f34e4"
      principal_name       = "eMobility Firmware Admin"
      role_definition_name = "Storage Blob Data Owner"
    }
  ]
}