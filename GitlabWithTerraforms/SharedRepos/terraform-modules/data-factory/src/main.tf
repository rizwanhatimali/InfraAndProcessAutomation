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
data "azurerm_client_config" "current" {}

resource "time_static" "this" {}

locals {
  key_name             = "${var.data_factory_name}-cmk"
  year_to_days         = var.encryption_key_years_to_expire * 365
  months_before_expiry = (var.encryption_key_years_to_expire * 12) - 1
  days_to_hours        = local.year_to_days * 24
  expiration_date      = timeadd(time_static.this.rfc3339, "${local.days_to_hours}h")
  tags                 = var.tags
  key_vault_roles      = ["Key Vault Secrets User", "Key Vault Crypto Service Encryption User"]
}
resource "azurerm_key_vault_key" "generated" {
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

resource "azurerm_user_assigned_identity" "identity" {
  name                = "ID-${var.data_factory_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each             = { for role in local.key_vault_roles : role => role }
  scope                = var.key_vault_id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
  depends_on = [
    azurerm_user_assigned_identity.identity,
  ]
}

resource "azurerm_data_factory" "data_factory" {
  name                = var.data_factory_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
  depends_on = [
    azurerm_user_assigned_identity.identity,
    azurerm_role_assignment.role_assignment
  ]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  customer_managed_key_identity_id = azurerm_user_assigned_identity.identity.id
  customer_managed_key_id          = azurerm_key_vault_key.generated.id

  dynamic "vsts_configuration" {
    for_each = var.git_configuration_enabled ? [1] : []
    content {
      account_name    = var.organization
      branch_name     = var.collaboration_branch_name
      project_name    = var.project_name
      repository_name = var.repository_name
      root_folder     = var.root_folder
      tenant_id       = data.azurerm_client_config.current.tenant_id
    }
  }

}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name                       = "Data factory logs"
  target_resource_id         = azurerm_data_factory.data_factory.id
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
