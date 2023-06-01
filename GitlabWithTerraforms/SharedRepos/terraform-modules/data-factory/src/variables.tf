variable "subscription_id" {
  type        = string
  description = "The id of the subscription to deploy to"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the Azure Data Factory."
}

variable "data_factory_name" {
  type        = string
  description = "The name of the Azure Data Factory."
}

variable "location" {
  type        = string
  description = "The location for the Azure Data Factory."
}

variable "key_vault_id" {
  type        = string
  description = "The id of the key vault in which the encryption key will be stored"
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

variable "private_endpoint_name" {
  type        = string
  description = "The name of the private endpoint for the data factory."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The resource ID of the subnet for the private endpoint."
  default     = null
}

variable "log_retention_days" {
  type        = number
  description = "The number of days to retain the logs"
  default     = 90
}

variable "organization" {
  description = "The organization that the ADF git configurtation is in"
  type        = string
}

variable "project_name" {
  description = "The name of the git project that the ADF git configurtation is in"
  type        = string
}

variable "repository_name" {
  description = "The name of the git repository that the ADF git configurtation is in"
  type        = string
}

variable "collaboration_branch_name" {
  description = "The name of the collaboration branch, this is were all of the ADF changes are merged to"
  type        = string
}

variable "root_folder" {
  description = "The folder in the repository where the ADF configuration is to be stored"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "The tags"
  default     = {}

}

variable "git_configuration_enabled" {
  description = "If the git configuration is enabled"
  type        = bool
  default     = false

}