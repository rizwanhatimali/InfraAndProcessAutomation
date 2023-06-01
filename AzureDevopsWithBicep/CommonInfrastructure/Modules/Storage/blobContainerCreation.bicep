//  This bicep script will create containers within the named storage account
param storageAccountName string
param containers array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' existing  = {
  name: storageAccountName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource storageAccounts_containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = [for (container, i) in containers: {
  parent: blobServices
  name: container
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}]
