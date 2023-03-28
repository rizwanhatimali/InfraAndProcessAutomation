param nicName string
param logWorkspaceId string

resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' existing = {
  name: nicName
}

resource setting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Metrics'
  scope: nic
  properties: {
    logs: []
    metrics: [
      { 
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    workspaceId: logWorkspaceId
  }
}
