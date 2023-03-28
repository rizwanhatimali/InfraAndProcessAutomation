[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $KeyVaultName,
    [Parameter(Mandatory = $true)]
    [string]
    $SecretName,
    [Parameter(Mandatory = $true)]
    [string]
    $VariableName
)

$secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName
$exists = $false
if($null -ne $secret){
    $exists = $true
}

Write-Host "##vso[task.setvariable variable=$($VariableName);]$exists"