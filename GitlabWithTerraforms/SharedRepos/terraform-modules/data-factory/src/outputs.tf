output "id" {
  description = "The id of the data factor"
  value       = azurerm_data_factory.data_factory.id
}

output "name" {
  description = "The data factory name"
  value       = azurerm_data_factory.data_factory.name
}

output "principal_id" {
  description = "The principal id"
  value       = azurerm_user_assigned_identity.identity.principal_id
}

output "identity_id" {
  description = "The id of the user assigned identity"
  value       = azurerm_user_assigned_identity.identity.id
}