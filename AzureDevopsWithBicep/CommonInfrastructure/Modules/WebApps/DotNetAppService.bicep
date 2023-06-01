param location string = resourceGroup().location

@description('The name of the storage account to be used by the AppService ')
param storageAccountName string
param environment string
param logWorkspaceId string
param logWorkspaceResourceGroup string

param appName string
param appServicePlanName string
param appSubnetName string
param appVnetName string
param appVnetResourceGroup string
param integrationSubnetName string
param integrationVnetName string
param integrationVnetResourceGroup string
param authenticationClientId string
param kind string

param tenantId string = subscription().tenantId
param keyVaultName string

param appConfigurationName string


var appConfigurationServiceUrl = 'https://${appConfigurationName}.azconfig.io'


var integrationScope = resourceGroup(integrationVnetResourceGroup)

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logWorkspaceId
  scope: resourceGroup(logWorkspaceResourceGroup)
}

resource integrationVnet 'Microsoft.Network/virtualnetworks@2015-05-01-preview' existing ={
  name: integrationVnetName
  scope: integrationScope
}

resource integrationSubnet 'Microsoft.Network/virtualnetworks/subnets@2015-06-15' existing = {
  parent: integrationVnet
  name: integrationSubnetName
}

resource appResource 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlanName
    enabled: true
    siteConfig: {
      ftpsState: 'FtpsOnly'
      alwaysOn: true
      http20Enabled: true
    }
    httpsOnly: true
    clientCertEnabled: true
    clientCertMode: 'OptionalInteractiveUser'
    virtualNetworkSubnetId: integrationSubnet.id 
    vnetRouteAllEnabled:true
  }
}

resource appConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appResource
  name: 'web'
  properties: {
    netFrameworkVersion: 'v6.0'
    minTlsVersion: '1.2'
    http20Enabled: true
    alwaysOn: true
    use32BitWorkerProcess: false
  }
}

resource appAuthSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'authsettingsV2'
  parent: appResource
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'Return401'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        login: {
          disableWWWAuthenticate: false
        }
        registration: {
          clientId: authenticationClientId
          clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
          openIdIssuer: 'https://sts.windows.net/${tenantId}/v2.0'
        }
        validation: {
          allowedAudiences: []
          defaultAuthorizationPolicy: {
            allowedPrincipals: {}
          }
        }
      }
    }
    login: {
      allowedExternalRedirectUrls: []
      preserveUrlFragmentsForLogins: false
      routes: {}
      tokenStore: {
        enabled: true
        tokenRefreshExtensionHours: 72
        fileSystem: {}
        azureBlobStorage: {}
      }
      cookieExpiration: {
        convention: 'FixedTime'
        timeToExpiration: '08:00:00'
      }
      nonce: {
        validateNonce: true
        nonceExpirationInterval: '00:05:00'
      }
    }
  }
  dependsOn: [
    appConfig
  ]
}

module privateEndpoints '../Network/privateEndPoints.bicep' = {
  name: 'App_Endpoint_${appName}'
  params: {
    location: location
    privateLinkName: 'PE-${appName}'
    privateLinkGroupIds: [ 'sites' ]
    networkInterfaceName: 'NIC-${appName}'
    privateLinkServiceId: appResource.id
    subnetId: '${subscription().id}/resourceGroups/${appVnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${appVnetName}/subnets/${appSubnetName}'
    logWorkspaceId: logWorkspace.id
  }
}


resource virtualNetworkIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  parent: appResource
  name: integrationSubnetName
  properties:{
    vnetResourceId: integrationSubnet.id
    isSwift: true
  }
}

module appSettings 'appSettings.bicep' = {
  name: '${appResource.name}--appSettings'
  params: {
    webAppName: appResource.name
    currentAppSettings: list(resourceId('Microsoft.Web/sites/config', appResource.name, 'appsettings'), '2022-03-01').properties
    appSettings: {
      APPINSIGHTS_CONNECTIONSTRING: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=APPINSIGHTS-CONNECTIONSTRING)'
      Environment: environment
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
      WEBSITE_RUN_FROM_PACKAGE: '1'
      WEBSITE_DNS_SERVER: '10.76.127.200'
      WEBSITE_DNS_ALT_SERVER: '10.76.127.201'
      MICROSOFT_PROVIDER_AUTHENTICATION_SECRET: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=MICROSOFT-PROVIDER-AUTHENTICATION-SECRET-${storageAccountName})'
      AppConfig_Endpoint: appConfigurationServiceUrl
      AzureWebJobsStorage: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=AzureWebJobsStorage-${storageAccountName})'
    }
  }
}
