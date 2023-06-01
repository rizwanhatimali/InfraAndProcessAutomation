[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]      
    [string]
    $subscription,  
    [Parameter(Mandatory = $true)]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("create", "validate", "what-if")]
    $command,
    [Parameter(Mandatory = $true)] 
    $keyVaultName,
    [Parameter(Mandatory = $true)] 
    $vnetName,
    [Parameter(Mandatory = $true)] 
    $subnetName,
    [Parameter(Mandatory = $true)] 
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)] 
    $retentionPeriod,
    [Parameter(Mandatory = $true)] 
    [string]
    $logWorkspaceId,
    [Parameter(Mandatory = $true)] 
    [string]
    $logWorkspaceResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

$deploymentName = "Deploy-$($keyVaultName)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/KeyVault/keyVault.bicep" `
    --parameters  location="$($location)" `
    keyVaultName="$($keyVaultName)" `
    retentionPeriod=$($retentionPeriod) `
    vnetName="$($vnetName)" `
    subnetName="$($subnetName)" `
    vnetResourceGroup="$($vnetResourceGroup)" `
    logWorkspaceId="$($logWorkspaceId)" `
    logWorkspaceResourceGroup="$($logWorkspaceResourceGroup)" `
    location=$($location)
