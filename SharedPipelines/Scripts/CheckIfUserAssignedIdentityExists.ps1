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
    $exists = $false
    if ($null -ne $id) {
        $exists = $true
        Write-Host "User assigned identity $($userAssignedIdentityName) found"
    }else{
        Write-Host "User assigned identity $($userAssignedIdentityName) not found"
    }
}
catch {
    $exists = $false
    Write-Host "User assigned identity $($userAssignedIdentityName) not found"
}

Write-Host "##vso[task.setvariable variable=$($VariableName);]$exists"