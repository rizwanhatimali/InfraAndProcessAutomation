output "id" {
  description = "The id of the azure purview"
  value       = azurerm_purview_account.azure_purview.id
}

output "name" {
  description = "azure purview name"
  value       = azurerm_purview_account.azure_purview.name
}

output "principal_id" {
  description = "azure purview principal id"
  value       = azurerm_purview_account.azure_purview.identity[0].principal_id
}