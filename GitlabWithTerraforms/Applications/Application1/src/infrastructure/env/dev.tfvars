resource_group_name = "RG-eMobility-Firmware-Dev"
workspace_name      = "LOG-eMobility-Firmware-DEV"

key_vault_name = "KV-Firmware-DEV"
key_vault_roles = [
  {
    name                 = "Reader"
    principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
    principal_name       = "eMobility Firmware Key Vault Reader"
    role_definition_name = "Key Vault Reader"
  },
  {
    name                 = "Reader-Secrets"
    principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
    principal_name       = "eMobility Firmware Key Vault Reader"
    role_definition_name = "Key Vault Secrets User"
  },
  {
    name                 = "Reader-Keys"
    principal_id         = "4999ce84-4615-443e-b71a-15270d9357cc"
    principal_name       = "eMobility Firmware Key Vault Reader"
    role_definition_name = "Key Vault Crypto User"
  },
  {
    name                 = "Admin"
    principal_id         = "86fe273f-c8b8-4d83-8876-dc57676c53f5"
    principal_name       = "eMobility Firmware Key Vault Manager"
    role_definition_name = "Key Vault Administrator"
  }
]

storage_account_name = "stfirmwaredev"
storage_roles = [
  {
    name                 = "User"
    principal_id         = "b879cec6-94e6-4965-a6cc-5c9f256bca13"
    principal_name       = "eMobility Firmware Upload"
    role_definition_name = "Storage Blob Data Contributor"
  },
  {
    name                 = "Testers"
    principal_id         = "bf2b25df-94ff-4b14-9f26-f2bfbc006c45"
    principal_name       = "eMobility Firmware Testers"
    role_definition_name = "Storage Blob Data Contributor"
  },
  {
    name                 = "Developers"
    principal_id         = "d03023d5-b228-49f3-b307-308368df6139"
    principal_name       = "eMobility Firmware Developers"
    role_definition_name = "Storage Blob Data Contributor"
  },
  {
    name                 = "Admin"
    principal_id         = "0786f372-8837-4e64-a3de-0788244f34e4"
    principal_name       = "eMobility Firmware Admin"
    role_definition_name = "Storage Blob Data Owner"
  }
]
