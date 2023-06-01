param storageAccountName string
param queues array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' existing  = {
  name: storageAccountName
}

resource queueServices 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource queueResources 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-05-01' = [for (queue, i) in queues:{
  parent: queueServices
  name: queue
}]