param storageAccountName string
param containerName string
param roleAssignments array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' existing  = {
  name: storageAccountName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource storageAccount_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: blobServices
  name: containerName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for (roleAssignment, i) in roleAssignments: {
  scope: storageAccount_container
  name: guid(storageAccount_container.id, roleAssignment.ObjectId, roleAssignment.RoleId)
  properties: {
    roleDefinitionId: roleAssignment.RoleId
    principalId: roleAssignment.ObjectId
    principalType: roleAssignment.Type
  }
  
}]
