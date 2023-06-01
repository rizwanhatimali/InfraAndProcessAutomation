location                               = "westeurope"
log_workspace_sku                      = "PerGB2018"
log_retention_in_days                  = 90
key_vault_deletion_retention_days      = 90
storage_retention_days                 = 90
storage_encryption_key_years_to_expire = 3
subscription_id                        = "173ca103-a555-45e3-b5e9-58d11c4f2f72"

cosmosdb_max_throughput = 4000
mongodb_database_name   = "Virta"
failover_location       = "northeurope"
mongo_collections = [{
  name      = "Configuration"
  shard_key = "id"
  indexes = [
    {
      name   = "_id"
      keys   = ["_id"]
      unique = true
    }
  ]
  },
  {
    name      = "ChargingStation"
    shard_key = "locationId"
    indexes = [
      {
        name   = "_id"
        keys   = ["_id"]
        unique = true
      }
    ]
  },
  {
    name      = "Customer"
    shard_key = "id"
    indexes = [
      {
        name   = "_id"
        keys   = ["_id"]
        unique = true
      }
    ]
  }
]

coordinator_vcore_count = 4
node_count              = 0

