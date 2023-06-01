param appConfiurationServiceName string
param appConfigurationSku string = 'standard'
param retentionDays int = 7
param location string = resourceGroup().location
param subnetName string
param vnetName string
param vnetResourceGroup string
param logWorkspaceName string
param logWorkspaceResourceGroup string
param keyVaultName string


resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceName
  scope: resourceGroup(logWorkspaceResourceGroup)
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: appConfiurationServiceName
  location: location
  sku: {
    name: appConfigurationSku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties:{
    createMode: 'Default'
    disableLocalAuth: true
    enablePurgeProtection: true
    publicNetworkAccess: 'Disabled'
    softDeleteRetentionInDays: retentionDays
  } 
}

module appConfigurationPrivateEndpoint '../Network/privateEndPoints.bicep' = {
  name: 'Deploy-PrivateEnpoint-${appConfiurationServiceName}'
  params:{
    privateLinkName: 'PE-${appConfiurationServiceName}'
    networkInterfaceName: 'NIC-${appConfiurationServiceName}'
    privateLinkGroupIds:['configurationStores']
    privateLinkServiceId: appConfiguration.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}'
    logWorkspaceId: logWorkspace.id
    location: location
  }
}

module keyVaultRoleAssignment '../KeyVault/keyVaultRoleAssignment.bicep' ={
  name: 'Assign-roles-for-${appConfiurationServiceName}-to-${keyVaultName}'
  params:{
    keyVaultName: keyVaultName
    objectId: appConfiguration.identity.principalId
    roleAssignments:[
      {
        RoleId: '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'
        Type: 'ServicePrincipal'
      }
      {
        RoleId: '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/12338af0-0e69-4776-bea7-57ae8d297424'
        Type: 'ServicePrincipal'
      }
    ]
  }
}
