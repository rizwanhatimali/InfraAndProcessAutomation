param location string = resourceGroup().location

param storageAccountName string
param retensionPolicy int = 112

param targetSubnetName string
param targetVnetName string
param vnetResourceGroupName string

param logWorkspaceId string
param logWorkspaceResourceGroup string

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceId
  scope: resourceGroup(logWorkspaceResourceGroup)
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Disabled'
    accessTier: 'Hot'
    encryption:{
      keySource: 'Microsoft.Storage'
      services:{
        blob:{
          keyType: 'Account'
          enabled:true
        }
        file:{
          keyType: 'Account'
          enabled: true
        }
        queue:{
          enabled: true
          keyType: 'Account'
        }
        table:{
          keyType: 'Account'
          enabled: true
        }
      }
    }
    networkAcls:{
      defaultAction:'Deny'
    }
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: retensionPolicy
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: retensionPolicy
    }
  }
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    shareDeleteRetentionPolicy: {
      enabled: true
      days: retensionPolicy
    }
  }
  dependsOn:[
    blobServices
  ]
}


resource queueServices 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  parent: storageAccount
  name: 'default'
  dependsOn:[
    fileServices
  ]
}

resource tableServices 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  parent: storageAccount
  name: 'default'
  dependsOn:[
    queueServices
  ]
}

resource dianosticsSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Transaction Metrics'
  scope: storageAccount
  properties: {
    logs: []
    metrics: [
      { 
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
        category: 'Transaction'
      }
    ]
    workspaceId: logWorkspace.id
  }
}

resource blobDianosticsSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Blob logs and Transactions'
  scope: blobServices
  properties: {
    logs: [
      {
        category: 'StorageRead'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageWrite'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageDelete'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
    ]
    metrics: [
      { 
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
        category: 'Transaction'
      }
    ]
    workspaceId: logWorkspace.id
  }
  dependsOn:[
    dianosticsSetting
  ]
}

resource queueDianosticsSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Queue logs and Transactions'
  scope: queueServices
  properties: {
    logs: [
      {
        category: 'StorageRead'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageWrite'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageDelete'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
    ]
    metrics: [
      { 
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
        category: 'Transaction'
      }
    ]
    workspaceId: logWorkspace.id
  }
  dependsOn:[
    blobDianosticsSetting
  ]
}

resource fileDianosticsSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'File logs and Transactions'
  scope: fileServices
  properties: {
    logs: [
      {
        category: 'StorageRead'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageWrite'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageDelete'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
    ]
    metrics: [
      { 
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
        category: 'Transaction'
      }
    ]
    workspaceId: logWorkspace.id
  }
  dependsOn:[
    queueDianosticsSetting
  ]
}

resource tableDianosticsSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Table logs and Transactions'
  scope: tableServices
  properties: {
    logs: [
      {
        category: 'StorageRead'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageWrite'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
      {
        category: 'StorageDelete'
        categoryGroup: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
      }
    ]
    metrics: [
      { 
        enabled: true
        retentionPolicy: {
          enabled: true
          days: retensionPolicy
        }
        category: 'Transaction'
      }
    ]
    workspaceId: logWorkspace.id
  }
  dependsOn:[
    fileDianosticsSetting
  ]
}

module blobPrivateEnpoint '../Network/privateEndPoints.bicep' = {
  name: 'Blob-${storageAccountName}'
  params:{
    location: location
    privateLinkName: 'PE-${storageAccountName}-Blob'
    privateLinkGroupIds: ['blob']
    networkInterfaceName: 'NIC-${storageAccountName}-Blob'
    privateLinkServiceId: storageAccount.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${targetVnetName}/subnets/${targetSubnetName}'
    logWorkspaceId: logWorkspace.id
  }
  dependsOn:[
    tableDianosticsSetting
    blobDianosticsSetting
    queueDianosticsSetting
    fileDianosticsSetting
  ]
}

module queuePrivateEnpoint '../Network/privateEndPoints.bicep' = {
  name: 'Queue-${storageAccountName}'
  params: {
    location: location
    privateLinkName: 'PE-${storageAccountName}-Queue'
    privateLinkGroupIds: ['queue']
    networkInterfaceName: 'NIC-${storageAccountName}-Queue'
    privateLinkServiceId: storageAccount.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${targetVnetName}/subnets/${targetSubnetName}'
    logWorkspaceId: logWorkspace.id
  }
  dependsOn:[
    blobPrivateEnpoint
  ]
}

module tablePrivateEnpoint '../Network/privateEndPoints.bicep' = {
  name: 'Table-${storageAccountName}'
  params: {
    location: location
    privateLinkName: 'PE-${storageAccountName}-Table'
    privateLinkGroupIds: ['table']
    networkInterfaceName: 'NIC-${storageAccountName}-Table'
    privateLinkServiceId: storageAccount.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${targetVnetName}/subnets/${targetSubnetName}'
    logWorkspaceId: logWorkspace.id
    
  }
  dependsOn:[
    queueDianosticsSetting
  ]
}

module filesPrivateEnpoint '../Network/privateEndPoints.bicep' = {
  name: 'Files-${storageAccountName}'
  params: {
    location: location
    privateLinkName: 'PE-${storageAccountName}-File'
    privateLinkGroupIds: ['file']
    networkInterfaceName: 'NIC-${storageAccountName}-File'
    privateLinkServiceId: storageAccount.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${targetVnetName}/subnets/${targetSubnetName}'
    logWorkspaceId: logWorkspace.id
  }
  dependsOn:[
    tableDianosticsSetting
  ]
}

var blobStorageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'

output connectionString string = blobStorageConnectionString
