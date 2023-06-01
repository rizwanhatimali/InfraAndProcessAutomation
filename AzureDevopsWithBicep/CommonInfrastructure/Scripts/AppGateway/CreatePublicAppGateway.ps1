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
    $vnetName,
    [Parameter(Mandatory = $true)] 
    $subnetName,
    [Parameter(Mandatory = $true)] 
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)] 
    $logWorkspaceName,
    [Parameter(Mandatory = $true)] 
    $gatewayName,
    [Parameter(Mandatory = $true)] 
    $firewallPolicyName,
    [Parameter(Mandatory = $true)] 
    $location
)

$timeStamp = (Get-Date).ToFileTime()
$deploymentName = "Deploy-$($gatewayName)-$($timeStamp)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/AppGateway/PublicGateway.bicep" `
    --parameters  location="$($location)" `
    gatewayName="$($gatewayName)" `
    firewallPolicyName=$($firewallPolicyName) `
    vnetName="$($vnetName)" `
    subnetName="$($subnetName)" `
    vnetResourceGroup="$($vnetResourceGroup)" `
    logWorkspaceName="$($logWorkspaceName)"