param location string = resourceGroup().location
param name string
param sku string
param retentionPeriod int = 30

resource LogWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties:{
    sku:{
      name: sku
    }
    retentionInDays: retentionPeriod
  }
}
