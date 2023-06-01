resource_group_name = "RG-eMobility-Operator-Integration-Run"
workspace_name      = "Log-eMobility-Operator-Run"

key_vault_name = "KV-eMob-Operator-Run"
key_vault_roles = [
  {
    name                 = "Reader"
    principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
    principal_name       = "eMobility Operators Key Vault Reader"
    role_definition_name = "Key Vault Reader"
  },
  {
    name                 = "Reader-Secrets"
    principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
    principal_name       = "eMobility Operators Key Vault Reader"
    role_definition_name = "Key Vault Secrets User"
  },
  {
    name                 = "Reader-Keys"
    principal_id         = "d529ebe5-f2e3-459b-9e2c-f51f4116949c"
    principal_name       = "eMobility Operators Key Vault Reader"
    role_definition_name = "Key Vault Crypto User"
  },
  {
    name                 = "Admin"
    principal_id         = "cab2088c-229d-4f44-acbb-f13770a4aefb"
    principal_name       = "eMobility Operators Key Vault Manager"
    role_definition_name = "Key Vault Administrator"
  }
]

storage_account_name = "stadfoperatorrun"
storage_roles = [
  {
    name                 = "Testers"
    principal_id         = "adf873af-0ca8-4cd4-a335-b00b936d99d8"
    principal_name       = "eMobility Operators Testers"
    role_definition_name = "Storage Blob Data Contributor"
  },
  {
    name                 = "Developers"
    principal_id         = "2ad0a2ff-1efd-49f8-84e1-bb595f398555"
    principal_name       = "eMobility Operators Developers"
    role_definition_name = "Storage Blob Data Contributor"
  },
  {
    name                 = "Admin"
    principal_id         = "56124967-5587-4c27-8f9f-25cc3f51a75c"
    principal_name       = "eMobility Operators Admin"
    role_definition_name = "Storage Blob Data Owner"
  }
]

data_factory_name = "ADF-Operator-Run"

cosmosdb_account_name = "cosmon-operators-run"

cluster_name = "cospos-emobility-operators-run"
