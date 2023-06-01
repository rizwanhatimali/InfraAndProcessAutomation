variable "subscription_id" {
  type        = string
  default     = "173ca103-a555-45e3-b5e9-58d11c4f2f72"
  description = "The id of the subscription to deploy to"
}

variable "cluster_name" {
  type        = string
  description = "The name of the Azure Cosmos DB for PostgreSQL cluster"
  default     = "cospos-emobility-operators-dev"
}

variable "resource_group_name" {
  type        = string
  default     = "RG-eMobility-Firmware-QAS"
  description = "The name of the resource group"
}

variable "key_vault_name" {
  type        = string
  default     = "KV-Firmware-Qas"
  description = "The name of the  key vault"
}

variable "admin" {
  type        = string
  default     = ""
  description = "The admin password"
}