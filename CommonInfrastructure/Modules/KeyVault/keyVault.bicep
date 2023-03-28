param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param keyVaultName string
param retentionPeriod int
param subnetName string
param vnetName string
param vnetResourceGroup string
param logWorkspaceId string
param logWorkspaceResourceGroup string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceId
  scope: resourceGroup(logWorkspaceResourceGroup)
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    softDeleteRetentionInDays: retentionPeriod
    tenantId: tenantId
    accessPolicies: []
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Deny'
    }
  }
}

resource setting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Key vault logs'
  scope: keyVault
  properties: {
    logs: [
      {
        category: null
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retentionPeriod
        }
      }
      {
        category: null
        categoryGroup: 'alllogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retentionPeriod
        }
      }
    ]
    metrics: [
      { 
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retentionPeriod
        }
      }
    ]
    workspaceId: logWorkspace.id
  }
}

module privateEndpoints '../Network/privateEndPoints.bicep' = {
  name: 'privateEndpoint_${keyVaultName}'
  params:{
    privateLinkName: 'pe-${keyVaultName}'
    privateLinkGroupIds:['vault']
    networkInterfaceName: 'NIC-${keyVaultName}'
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}'
    privateLinkServiceId: keyVault.id
    location: location
    logWorkspaceId: logWorkspace.id
  }
}
