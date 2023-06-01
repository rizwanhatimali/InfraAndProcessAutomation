param storageAccountName string
param queueName string
param roleAssignments array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' existing  = {
  name: storageAccountName
}

resource queueServices 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-05-01' existing = {
  parent: queueServices
  name: queueName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for (roleAssignment, i) in roleAssignments: {
  scope: queue
  name: guid(queue.id, roleAssignment.ObjectId, roleAssignment.RoleId)
  properties: {
    roleDefinitionId: roleAssignment.RoleId
    principalId: roleAssignment.ObjectId
    principalType: roleAssignment.Type
  }
  
}]
