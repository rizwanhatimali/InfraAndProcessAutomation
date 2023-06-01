variable "subscription_id" {
  type        = string
  description = "The id of the subscription to deploy to"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the Azure Data Factory."
}

variable "microsoft_purview_name" {
  type        = string
  description = "The name of the Microsoft Purview."
}

variable "location" {
  type        = string
  description = "The location for the Azure Purview."
}

variable "tags" {
  type        = map(string)
  description = "The tags"
  default     = {}
}

variable "log_retention_days" {
  type        = number
  description = "The number of days to retain the logs"
  default     = 90
}

variable "log_workspace_id" {
  type        = string
  description = "The id of the log analytics workspace"
}