terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.55.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
  }
}

resource "time_static" "this" {}

locals {
  key_name             = "${var.storage_account_name}-cmk"
  year_to_days         = var.encryption_key_years_to_expire * 365
  months_before_expiry = (var.encryption_key_years_to_expire * 12) - 1
  days_to_hours        = local.year_to_days * 24
  expiration_date      = timeadd(time_static.this.rfc3339, "${local.days_to_hours}h")
  tags                 = var.tags
  services             = ["blobServices", "queueServices", "tableServices", "fileServices"]
}

resource "azurerm_key_vault_key" "storage_account_key" {
  name         = local.key_name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  not_before_date = time_static.this.rfc3339
  expiration_date = local.expiration_date

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P${local.year_to_days}D"
    notify_before_expiry = "P40D"
  }

  lifecycle {
    ignore_changes = [
      expiration_date,
      not_before_date
    ]
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = var.account_replication_type
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  access_tier                     = "Hot"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  queue_encryption_key_type       = "Account"
  table_encryption_key_type       = "Account"
  is_hns_enabled                  = var.is_hns_enabled
  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  blob_properties {
    change_feed_enabled = false
    container_delete_retention_policy {
      days = var.retention_days
    }
    delete_retention_policy {
      days = var.retention_days
    }
  }
  lifecycle {
    ignore_changes = [
      identity
    ]
  }
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.storage_account.id

  default_action = "Allow"
  bypass         = ["AzureServices"]
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.storage_account.identity[0].principal_id
  depends_on = [
    azurerm_storage_account.storage_account,
    azurerm_key_vault_key.storage_account_key
  ]
}

resource "azurerm_storage_account_customer_managed_key" "configure-cmk" {
  storage_account_id = azurerm_storage_account.storage_account.id
  key_vault_id       = var.key_vault_id
  key_name           = azurerm_key_vault_key.storage_account_key.name
  depends_on = [azurerm_key_vault_key.storage_account_key,
  azurerm_role_assignment.role_assignment]
}

resource "azurerm_monitor_diagnostic_setting" "storage-diagnostic" {
  name                       = "Storage Account Transactions"
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.log_workspace_id
  metric {
    category = "Transaction"
    enabled  = true
    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }
  depends_on = [azurerm_storage_account.storage_account]
}
resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  for_each                   = { for service in local.services : service => service }
  name                       = "${each.key}-diagnostic-settings"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/${each.key}/default/"
  log_analytics_workspace_id = var.log_workspace_id

  enabled_log {
    category = "StorageRead"
    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }

  enabled_log {
    category = "StorageWrite"

    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }

  enabled_log {
    category = "StorageDelete"

    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }

  metric {
    category = "Transaction"
    enabled  = true
    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }
  depends_on = [azurerm_monitor_diagnostic_setting.storage-diagnostic]
}
