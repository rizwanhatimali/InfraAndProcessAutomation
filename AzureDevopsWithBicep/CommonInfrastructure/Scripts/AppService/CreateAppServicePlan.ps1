[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $subscription,    
    [Parameter(Mandatory = $true)]
    [string]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("create", "validate", "what-if")]
    $command,
    [Parameter(Mandatory = $true)]
    [string]
    $appPlanName,
    [Parameter(Mandatory = $true)]
    [string]
    $sku,
    [Parameter(Mandatory = $true)]
    [string]
    $kind,
    [Parameter(Mandatory = $true)]
    [string]
    $zoneRedundant,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name "Deploy-$($appPlanName)" `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/AppService/AppServicePlan.bicep" `
    --parameters  location="$($location)" `
    planName="$($appPlanName)" `
    sku=@$sku `
    kind=$kind `
    zoneRedundant=$($zoneRedundant -eq 'true')