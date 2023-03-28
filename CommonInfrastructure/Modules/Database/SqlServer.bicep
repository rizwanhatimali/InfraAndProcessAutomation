param location string = resourceGroup().location
param sqlServerName string
param adminUser string
param adminObjectId string
param tenantId string = subscription().tenantId
param subscriptionId string = subscription().subscriptionId

param vnetName string
param subnetName string
param vnetResourceGroup string

param storageAccountName string

param logWorkspaceId string
param logRententionPeriod int = 90

var StorageBlobContributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
var storageEndpoint = 'https://${storageAccountName}.blob.${az.environment().suffixes.storage}/'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceId
}


resource sql_server_resource 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: adminUser
      sid: adminObjectId
      tenantId: tenantId
      azureADOnlyAuthentication: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource securityAlertPolicies 'Microsoft.Sql/servers/securityAlertPolicies@2021-11-01-preview' = {
  parent: sql_server_resource
  name: 'Default'
  properties: {
    state: 'Enabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource vulnerabilityAssessments 'Microsoft.Sql/servers/vulnerabilityAssessments@2021-11-01-preview' = {
  parent: sql_server_resource
  name: 'default'
  properties: {
    storageContainerPath: '${storageEndpoint}vulnerability-assessment/'
    recurringScans: {
      isEnabled: true
      emailSubscriptionAdmins: true
      emails: []
    }
  }
  dependsOn: [
    securityAlertPolicies
    storageAccount
  ]
}

resource masterDatabase 'Microsoft.Sql/servers/databases@2022-08-01-preview'  = {
  parent: sql_server_resource
  name: 'master'
  location: location
  properties:{}
}


resource MasterDatabase_ThreatProtectionSettings 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2022-02-01-preview' = {
  parent: masterDatabase
  name: 'default'
  properties: {
    state: 'Enabled'
  }
}


resource MasterDatabase_AuditPolicies 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: masterDatabase
  name: 'default'
  properties: {
    auditingState: 'Disabled'
  }
}

resource MasterDatabase_AuditSettings 'Microsoft.Sql/servers/databases/auditingSettings@2022-02-01-preview' = {
  parent: masterDatabase
  name: 'default'
  properties: {
    retentionDays: logRententionPeriod
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: true
    isManagedIdentityInUse: true
    state: 'Enabled'
    storageEndpoint: storageEndpoint
    storageAccountSubscriptionId: subscriptionId
  }
}

resource MasterDatabase_Extended_AuditSettings 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2022-02-01-preview' = {
 parent: masterDatabase
  name: 'default'
  properties: {
    retentionDays: logRententionPeriod
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: true
    isManagedIdentityInUse: true
    state: 'Enabled'
    storageEndpoint: storageEndpoint
    storageAccountSubscriptionId: subscriptionId
  }
}

resource roleAssignStorage 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(storageAccount.id, sql_server_resource.id, StorageBlobContributor)
  properties: {
    roleDefinitionId: StorageBlobContributor
    principalId: reference(sql_server_resource.id, '2020-08-01-preview', 'Full').identity.principalId
  }
  scope: storageAccount
} 

resource auditingsqlServer 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = {
  parent: sql_server_resource
  name: 'default'
  properties: {
    isDevopsAuditEnabled: false
    retentionDays: logRententionPeriod
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: true
    isManagedIdentityInUse: true
    state: 'Enabled'
    storageEndpoint: storageEndpoint
    storageAccountSubscriptionId: subscriptionId
  }
  dependsOn: [
    roleAssignStorage
  ] 
}

resource sql_server_resource_devOpsAuditingsqlServer 'Microsoft.Sql/servers/devOpsAuditingSettings@2022-02-01-preview' = {
  parent: sql_server_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: true
    isManagedIdentityInUse: true
    state: 'Enabled'
    storageEndpoint: storageEndpoint
    storageAccountSubscriptionId: subscriptionId
  }
  dependsOn: [
    auditingsqlServer
  ] 
}

resource Microsoft_Sql_servers_azureADOnlyAuthentications_servers_sql_pcps_dev_name_Default 'Microsoft.Sql/servers/azureADOnlyAuthentications@2022-02-01-preview' = {
  parent: sql_server_resource
  name: 'Default'
  properties: {
    azureADOnlyAuthentication: true
  }
}

resource masterDbDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'MasterDB_AuditDiagnosticSettings'
  scope: masterDatabase
  properties: {
    logs: [
      {
        category: null
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logRententionPeriod
        }
      }
      {
        category: null
        categoryGroup: 'alllogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logRententionPeriod
        }
      }
    ]
    metrics: [
      { 
        category: 'Basic'
        timeGrain: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logRententionPeriod
        }
      }
      { 
        category: 'InstanceAndAppAdvanced'
        timeGrain: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logRententionPeriod
        }
      }
      { 
        category: 'WorkloadManagement'
        timeGrain: null
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logRententionPeriod
        }
      }
    ]
    workspaceId: logWorkspace.id
  }
}

resource diagnosticSettingsMasterDatabase 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: masterDatabase
  name: 'SQLSecurityAuditEvents_masterdb'
  properties: {
    workspaceId: logWorkspace.id
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
        retentionPolicy: {
          days: logRententionPeriod
          enabled: true
        }
      }
      {
        category: 'DevOpsOperationsAudit'
        enabled: true
        retentionPolicy: {
          days: logRententionPeriod
          enabled: true
        }
      }
    ]
  }
  dependsOn:[
    masterDbDiagnosticSetting
  ]
}

module sqlServerPrivateEndpoint '../Network/privateEndPoints.bicep' = {
  name: 'sql-private-endpoint'
  params:{
    logWorkspaceId: logWorkspace.id
    privateLinkName: 'PE-${sql_server_resource.name}'
    networkInterfaceName: 'NIC-${sql_server_resource.name}'
    privateLinkGroupIds: ['sqlserver']
    privateLinkServiceId: sql_server_resource.id
    subnetId: '${subscription().id}/resourceGroups/${vnetResourceGroup}/providers/microsoft.network/virtualNetworks/${vnetName}/subnets/${subnetName}'
    location: location
  }
}
