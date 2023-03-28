param name string
param location string = resourceGroup().location
param retentionPeriod int
param logWorkspaceName string
param maximumThroughputUnits int = 15

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceName
}

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  identity:{
    type: 'SystemAssigned'
  }
  properties:{
    minimumTlsVersion: '1.2'
    zoneRedundant: true
    isAutoInflateEnabled: true
    maximumThroughputUnits: maximumThroughputUnits
    disableLocalAuth: true 
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'All logs'
  scope: namespace
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
