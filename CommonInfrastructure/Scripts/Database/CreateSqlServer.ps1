[CmdletBinding()]
param (
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
    $retentionPeriod,
    [Parameter(Mandatory = $true)]
    $environment,
    [Parameter(Mandatory = $true)] 
    $vnetName,
    [Parameter(Mandatory = $true)] 
    $subnetName,
    [Parameter(Mandatory = $true)] 
    $vnetResourceGroup,
    [Parameter(Mandatory = $true)] 
    $logWorkspaceId,
    [Parameter(Mandatory = $true)] 
    $sqlServerName,
    [Parameter(Mandatory = $true)] 
    $location,
    [Parameter(Mandatory = $true)]
    $adminUser,
    [Parameter(Mandatory = $true)]
    $adminObjectId,
    [Parameter(Mandatory = $true)]
    $auditStorageAccount
)

$timeStamp = (Get-Date).ToFileTime()
$deploymentName = "$($deploymentName)-$($timeStamp)"

az config set bicep.use_binary_from_path=false

az deployment group $command `
    --name $deploymentName `
    --subscription "$subscription" `
    --resource-group "$($resourceGroup)" `
    --template-file "../../Modules/Database/SqlServer.bicep" `
    --parameters  location="$($location)" `
    sqlServerName="$($sqlServerName)" `
    logRententionPeriod=$($retentionPeriod) `
    environment="$($environment)" `
    vnetName="$($vnetName)" `
    subnetName="$($subnetName)" `
    vnetResourceGroup="$($vnetResourceGroup)" `
    logWorkspaceId="$($logWorkspaceId)" `
    adminUser="$($adminUser)" `
    adminObjectId="$($adminObjectId)" `
    storageAccountName="$($auditStorageAccount)"