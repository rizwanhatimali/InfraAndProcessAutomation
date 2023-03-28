param location string = resourceGroup().location
param privateLinkName string
param privateLinkServiceId string
param privateLinkGroupIds array
param networkInterfaceName string
param subnetId string
param logWorkspaceId string

resource privateEndpoints_resource 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: privateLinkName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateLinkName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: privateLinkGroupIds
        }
      }
    ]
    customNetworkInterfaceName: networkInterfaceName
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId
    }
    customDnsConfigs: []
  }
}

var nicModuleName = 'Apply_Diagnostic_Settings_For_${networkInterfaceName}'

module nicDiagnosticSettings 'nicDiagnosticSettings.bicep' = {
  name: (length(nicModuleName) > 64)? substring(nicModuleName, 0, 63) : nicModuleName
  params:{
    logWorkspaceId: logWorkspaceId
    nicName: networkInterfaceName
  }
  dependsOn:[
    privateEndpoints_resource
  ]
}
