[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $location,    
    [Parameter(Mandatory = $true)]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $subscription,
    [Parameter(Mandatory = $true)]
    $deploymentName,
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("create", "validate", "what-if")]
    $command,
    [Parameter(Mandatory = $true)]
    $storageAccountName,
    [Parameter(Mandatory = $true)] 
    $retensionPolicy,
    [Parameter(Mandatory = $true)] 
    $vnetName,
    [Parameter(Mandatory = $true)] 
    $subnetName,
    [Parameter(Mandatory = $true)] 
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)]
    $logWorkspaceId
)

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/Storage/storageAccount.bicep" `
    --parameters  location="$($location)" `
    storageAccountName="$($storageAccountName)" `
    retensionPolicy=$($retensionPolicy) `
    targetVnetName="$($vnetName)" `
    targetSubnetName="$($subnetName)" `
    vnetResourceGroupName="$($vnetResourceGroup)" `
    logWorkspaceId="$($logWorkspaceId)"