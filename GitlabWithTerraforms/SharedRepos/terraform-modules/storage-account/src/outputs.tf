output "id" {
  description = "The id of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}