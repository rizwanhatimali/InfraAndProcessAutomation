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
    [string]
    $userIdentity,
    [Parameter(Mandatory = $true)] 
    [string]
    $vnetName,
    [Parameter(Mandatory = $true)]
    [string] 
    $subnetName,
    [Parameter(Mandatory = $true)]
    [string]
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $logWorkspaceName,
    [Parameter(Mandatory = $true)]
    [string]
    $registryName,
    [Parameter(Mandatory = $true)] 
    [string]
    $encryptionKeyName,
    [Parameter(Mandatory = $true)] 
    [string]
    $keyVaultName,
    [Parameter(Mandatory = $true)] 
    [string]
    $location
)

$timeStamp = (Get-Date).ToFileTime()
$deploymentName = "Deploy-$($registryName)-$($timeStamp)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/Containers/ContainerRegistry.bicep" `
    --parameters  location="$($location)" `
    registryName="$($registryName)" `
    userIdentity=$($userIdentity) `
    vnetName="$($vnetName)" `
    subnetName="$($subnetName)" `
    vnetResourceGroup="$($vnetResourceGroup)" `
    keyVaultName="$($keyVaultName)" `
    encryptionKeyName="$($encryptionKeyName)" `
    logWorkspaceName="$($logWorkspaceName)"