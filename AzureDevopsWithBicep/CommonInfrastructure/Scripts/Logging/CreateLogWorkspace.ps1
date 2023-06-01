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
    $logWorkspaceName,
    [Parameter(Mandatory = $true)] 
    $sku,
    [Parameter(Mandatory = $true)] 
    $retentionPeriod,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

$deploymentName = "Deploy-$($logWorkspaceName)"

try{
    [int]$retentionPeriodNum = $retentionPeriod
}
catch{
    [int]$retentionPeriodNum = 30
}

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/Logging/LogAnalyticsWorkspace.bicep" `
    --parameters location="$($location)" `
    name="$($logWorkspaceName)" `
    retentionPeriod=$([Int32]$retentionPeriod) `
    sku="$($sku)" 