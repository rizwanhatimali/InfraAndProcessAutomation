param location string = resourceGroup().location
param planName string
param sku object
param zoneRedundant bool = false
param kind string

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: planName
  location: location
  sku: sku
  kind: kind
  properties: {
    zoneRedundant: zoneRedundant
  }
}
