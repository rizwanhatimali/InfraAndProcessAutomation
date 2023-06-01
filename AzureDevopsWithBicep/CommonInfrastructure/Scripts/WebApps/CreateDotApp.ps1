[CmdletBinding()]
param (  
    [Parameter(Mandatory = $true)]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $subscription,
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("create", "validate", "what-if")]
    $command,
    [Parameter()] 
    $storageAccountName,
    [Parameter()] 
    $environment,
    [Parameter()] 
    $logWorkspaceId,
    [Parameter(Mandatory = $true)] 
    [string]
    $logWorkspaceResourceGroup,
    [Parameter()] 
    $appName,
    [Parameter()] 
    $appServicePlanName,
    [Parameter()] 
    $appSubnetName,
    [Parameter()] 
    $appVnetName,
    [Parameter()] 
    $appVnetResourceGroup,
    [Parameter()] 
    $integrationSubnetName,
    [Parameter()] 
    $integrationVnetName,
    [Parameter()] 
    $integrationVnetResourceGroup,
    [Parameter()] 
    $authenticationClientId,
    [Parameter()] 
    $keyVaultName,
    [Parameter()] 
    $appConfigurationName,
    [Parameter()] 
    $location,
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("functionapp", "app")]
    $kind
)

$deploymentName = "Deploy-$($appName)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/WebApps/DotnetFunctionApp.bicep" `
    --parameters  storageAccountName="$($storageAccountName)" `
    environment="$($environment)" `
    logWorkspaceId="$($logWorkspaceId)" `
    logWorkspaceResourceGroup="$($logWorkspaceResourceGroup)" `
    appName="$($appName)" `
    appServicePlanName="$($appServicePlanName)" `
    appSubnetName="$($appSubnetName)" `
    appVnetName="$($appVnetName)" `
    appVnetResourceGroup="$($appVnetResourceGroup)" `
    integrationSubnetName="$($integrationSubnetName)" `
    integrationVnetName="$($integrationVnetName)" `
    integrationVnetResourceGroup="$($integrationVnetResourceGroup)" `
    authenticationClientId="$($authenticationClientId)" `
    keyVaultName="$($keyVaultName)" `
    appConfigurationName="$($appConfigurationName)" `
    kind="$($kind)" `
    location=$location