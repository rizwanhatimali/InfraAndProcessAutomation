[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $ApplicationInsightsName,
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $VariableName
)

$appInsights = Get-AzApplicationInsights -ResourceGroupName $ResourceGroup -Name $ApplicationInsightsName

if($null -eq $appInsights){
    Write-Error "Unable to locate the app insights instance $($ApplicationInsightsName)"
    exit -1
}

$connectionString = $appInsights.ConnectionString

Write-Host "##vso[task.setvariable variable=$($VariableName);issecret=true;]$connectionString"