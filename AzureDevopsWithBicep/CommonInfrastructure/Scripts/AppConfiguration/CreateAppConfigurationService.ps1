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
    [Parameter(Mandatory = $true)] 
    $retentionPeriod,
    [Parameter(Mandatory = $true)] 
    $vnetName,
    [Parameter(Mandatory = $true)] 
    $subnetName,
    [Parameter(Mandatory = $true)] 
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)] 
    $logWorkspaceName,
    [Parameter(Mandatory = $true)] 
    $logWorkspaceResourceGroup,
    [Parameter(Mandatory = $true)] 
    $appConfigServiceName,
    [Parameter(Mandatory = $true)] 
    $appConfigServiceSku,
    [Parameter(Mandatory = $true)] 
    $keyVaultName,
    [Parameter(Mandatory = $true)] 
    $location
)

$timeStamp = (Get-Date).ToFileTime()
$deploymentName = "Deploy-$($appConfigServiceName)-$($timeStamp)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/AppConfiguration/appConfiguration.bicep" `
    --parameters  location="$($location)" `
    appConfiurationServiceName="$($appConfigServiceName)" `
    retentionDays=$($retentionPeriod) `
    appConfigurationSku="$($appConfigServiceSku)" `
    vnetName="$($vnetName)" `
    subnetName="$($subnetName)" `
    vnetResourceGroup="$($vnetResourceGroup)" `
    keyVaultName="$($keyVaultName)" `
    logWorkspaceName="$($logWorkspaceName)" `
    logWorkspaceResourceGroup="$($logWorkspaceResourceGroup)" `
    location="$($location)"