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
    [string]
    $userAssignedIdentityName,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

$deploymentName = "Deploy-$($g)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/Identity/UserIdentity.bicep" `
    --parameters location="$($location)" `
    name="$($userAssignedIdentityName)"