[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $vaultName,
    [Parameter(Mandatory = $true)]
    [string]
    $resourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $servicePrincipal,
    [Parameter(Mandatory = $true)]
    [string[]]
    $roles
)

Write-Host "Get-AzKeyVault -ResourceGroupName $resourceGroup -VaultName $vaultName"
$keyVault = Get-AzKeyVault -ResourceGroupName $resourceGroup -VaultName $vaultName

if($null -eq $keyVault){
    Write-Error "Unable to locate key vault"
    exit -1
}

$scope = $keyVault.ResourceId
foreach ($role in $roles) {
    $existing = Get-AzRoleAssignment -ObjectId $servicePrincipal -RoleDefinitionName $role -Scope $scope

    if ($null -eq $existing) {
        New-AzRoleAssignment -ObjectId $servicePrincipal -RoleDefinitionName $role -Scope $scope | Out-Null
    }
    else {
        Write-Host "Role assignment $role already exists"
    }
}