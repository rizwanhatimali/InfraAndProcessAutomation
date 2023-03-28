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
    $applicationInsightsName,
    [Parameter(Mandatory = $true)] 
    [string]
    $logWorkspaceName,
    [Parameter(Mandatory = $true)]
    [string]
    $location
)

$deploymentName = "Deploy-$($applicationInsightsName)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/AppInsights/appInsights.bicep" `
    --parameters location="$($location)" `
    applicationInsightsName="$($applicationInsightsName)" `
    logAnalyticsWorkspaceName=$($logWorkspaceName)