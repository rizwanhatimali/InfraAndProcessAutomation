[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $subscription,
    [Parameter(Mandatory = $true)] 
    [string]
    $userAssignedIdentityName,
    [Parameter(Mandatory = $true)] 
    [string]
    $variableName
)

try {
    $id = Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -SubscriptionId $subscription -Name $userAssignedIdentityName
    Write-Host "##vso[task.setvariable variable=$($VariableName);]$($id.PrincipalId)"
}
catch {
    Write-Error "User assigned identity $($userAssignedIdentityName) not found"
    exit -1
}


