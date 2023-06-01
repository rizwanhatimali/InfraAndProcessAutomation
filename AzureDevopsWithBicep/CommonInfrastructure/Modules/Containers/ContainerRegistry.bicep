param registryName string
param userIdentity string
param keyVaultName string
param encryptionKeyName string
param subnetName string
param vnetName string
param vnetResourceGroup string
param logWorkspaceName string
param location string = resourceGroup().location

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceName
}

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userIdentity
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: 'Premium'
  }
  identity:{
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${identity.id}' : {}
    }
  }
  properties:{
    adminUserEnabled: false
    anonymousPullEnabled: false
    publicNetworkAccess: 'Disabled'
    zoneRedundancy: 'Enabled'
    encryption: {
      status: 'enabled'
      keyVaultProperties:{
        keyIdentifier: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/keys/${encryptionKeyName}'
        identity: identity.properties.clientId
      }
    }
  }
}

module privateEndpoint '../Network/privateEndPoints.bicep' = {
  name: 'PE-${registryName}'
  params:{
    location: location
    privateLinkName: 'PE-${registryName}'
    networkInterfaceName: 'NIC-${registryName}'
    privateLinkServiceId: containerRegistry.id
    privateLinkGroupIds: [
      'registry'
    ]
    logWorkspaceId: logWorkspace.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}'
  }
}
