param databaseAccounts_cosno_anchor_poc_name string = 'cosno-anchor-poc'
param privateEndpoints_PE_AnchorPoc_Cosmos_externalid string = '/subscriptions/bb471d58-b53c-45c1-843c-a418e8903a84/resourceGroups/RG-UKSolnsAnchor-POC/providers/Microsoft.Network/privateEndpoints/PE-AnchorPoc-Cosmos'

resource databaseAccounts_cosno_anchor_poc_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: databaseAccounts_cosno_anchor_poc_name
  location: 'UK South'
  tags: {
    defaultExperience: 'Core (SQL)'
    'hidden-cosmos-mmspecial': ''
    PSP: ''
  }
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    createMode: 'Default'
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: true
    enablePartitionMerge: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: 'UK South'
        failoverPriority: 0
        isZoneRedundant: true
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    ipRules: [
      {
        ipAddressOrRange: '104.42.195.92'
      }
      {
        ipAddressOrRange: '40.76.54.131'
      }
      {
        ipAddressOrRange: '52.176.6.30'
      }
      {
        ipAddressOrRange: '52.169.50.45'
      }
      {
        ipAddressOrRange: '52.187.184.26'
      }
    ]
    backupPolicy: {
      type: 'Continuous'
    }
    networkAclBypassResourceIds: []
    capacity: {
      totalThroughputLimit: 4000
    }
    keysMetadata: {}
  }
}

resource databaseAccounts_cosno_anchor_poc_name_PE_AnchorPoc_Cosmos 'Microsoft.DocumentDB/databaseAccounts/privateEndpointConnections@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_resource
  name: 'PE-AnchorPoc-Cosmos'
  properties: {
    provisioningState: 'Succeeded'
    groupId: 'Sql'
    privateEndpoint: {
      id: privateEndpoints_PE_AnchorPoc_Cosmos_externalid
    }
    privateLinkServiceConnectionState: {
      status: 'Approved'
    }
  }
}

resource databaseAccounts_cosno_anchor_poc_name_Anchor_POC 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_resource
  name: 'Anchor-POC'
  properties: {
    resource: {
      id: 'Anchor-POC'
    }
  }
}

resource databaseAccounts_cosno_anchor_poc_name_ToDoList 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_resource
  name: 'ToDoList'
  properties: {
    resource: {
      id: 'ToDoList'
    }
  }
}

resource databaseAccounts_cosno_anchor_poc_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosno_anchor_poc_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_cosno_anchor_poc_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosno_anchor_poc_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_cosno_anchor_poc_name_ToDoList_Items 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_ToDoList
  name: 'Items'
  properties: {
    resource: {
      id: 'Items'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/partitionKey'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
  dependsOn: [
    databaseAccounts_cosno_anchor_poc_name_resource
  ]
}

resource databaseAccounts_cosno_anchor_poc_name_Anchor_POC_products 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  parent: databaseAccounts_cosno_anchor_poc_name_Anchor_POC
  name: 'products'
  properties: {
    resource: {
      id: 'products'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/categoryId'
        ]
        kind: 'Hash'
        version: 2
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
  dependsOn: [
    databaseAccounts_cosno_anchor_poc_name_resource
  ]
}