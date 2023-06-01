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
  tags = var.tags
}

resource "azurerm_purview_account" "azure_purview" {
  name                = var.microsoft_purview_name
  resource_group_name = var.resource_group_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
  tags = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name                       = "LOGS-${var.microsoft_purview_name}"
  target_resource_id         = azurerm_purview_account.azure_purview.id
  log_analytics_workspace_id = var.log_workspace_id
  enabled_log {
    category_group = "alllogs"
    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      days    = var.log_retention_days
      enabled = true
    }
  }
}
