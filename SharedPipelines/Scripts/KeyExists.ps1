[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $KeyVaultName,
    [Parameter(Mandatory = $true)]
    [string]
    $KeyName,
    [Parameter(Mandatory = $true)]
    [string]
    $VariableName
)

$key = Get-AzKeyVaultKey -VaultName $KeyVaultName -Name $KeyName
$exists = $false
if($null -ne $key){
    $key = $true
}

Write-Host "##vso[task.setvariable variable=$($VariableName);]$exists"