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
    $namespaceName,
    [Parameter(Mandatory = $true)] 
    $retentionPeriod,
    [Parameter(Mandatory = $true)]
    $maximumThroughputUnits,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

$deploymentName = "Deploy-$($namespaceName)"

try{
    [int]$retentionPeriodNum = $retentionPeriod
}
catch{
    [int]$retentionPeriodNum = 30
}

try{
    [int]$maximumThroughput = $maximumThroughputUnits
}
catch{
    [int]$maximumThroughput = 15
}

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/EventHub/Namespace.bicep" `
    --parameters location="$($location)" `
    name="$($namespaceName)" `
    retentionPeriod=$($retentionPeriodNum) `
    maximumThroughputUnits=$($maximumThroughput) `
    logWorkspaceName="$($logWorkspaceName)" 