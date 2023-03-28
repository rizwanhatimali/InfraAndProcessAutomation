param name string 
param location string = resourceGroup().location

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

output id string = publicIPAddress.id
