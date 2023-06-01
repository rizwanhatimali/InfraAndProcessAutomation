variable "subscription_id" {
  type        = string
  default     = "173ca103-a555-45e3-b5e9-58d11c4f2f72"
  description = "The id of the subscription to deploy to"
}
variable "resource_group_name" {
  type        = string
  default     = "RG-eMobility-Firmware-Dev"
  description = "The name of the key vault"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault."
}

variable "user_roles" {
  type = list(object({
    name                 = string
    principal_id         = string
    principal_name       = string
    role_definition_name = string
  }))
  description = "The users and the roles that need to be applied to the key vault"
  default     = []
}
