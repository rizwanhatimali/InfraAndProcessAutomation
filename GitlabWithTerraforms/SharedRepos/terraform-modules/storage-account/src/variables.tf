variable "subscription_id" {
  type        = string
  default     = ""
  description = "The id of the subscription to deploy to"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy the storage account to"
  default     = "RG-xAPILayer-DEV"
}

variable "location" {
  type        = string
  description = "The location for the Azure Data Factory."
  default     = "westeurope"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
  default     = "sttest0001"
}

variable "key_vault_id" {
  type        = string
  description = "The id of the key vault in which the encryption key will be stored"
}
variable "retention_days" {
  type        = number
  description = "The number of days to retain deleted blobs"
  default     = 90
}

variable "encryption_key_years_to_expire" {
  type        = number
  description = "The number of years for the encryption key to expire."
  default     = 3
}

variable "log_workspace_id" {
  type        = string
  description = "The id of the log analytics workspace"
}

variable "log_retention_days" {
  type        = number
  description = "The number of days to retain the logs"
  default     = 90
}

variable "is_hns_enabled" {
  type        = bool
  description = "Is Hierarchical Namespace enabled"
  default     = true
}

variable "account_replication_type" {
  type        = string
  description = "Account Replication type"
  default     = "ZRS"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}