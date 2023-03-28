param target string
param roleAssignments array
param objectId string

resource scope 'Microsoft.AppConfiguration/configurationStores@2022-05-01' existing  = {
  name: target
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
