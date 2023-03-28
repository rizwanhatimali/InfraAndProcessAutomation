param keyVaultName string
param roleAssignments array
param objectId string

resource scope 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing  = {
  name: keyVaultName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for (roleAssignment, i) in roleAssignments:  {
  scope: scope
  name: guid(scope.id, objectId, roleAssignment.RoleId)
  properties: {
    roleDefinitionId: roleAssignment.RoleId
    principalId: objectId
    principalType: roleAssignment.Type
  }
  
}]
