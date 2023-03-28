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
    $Value,
    # The number of years before the secret expires
    [Parameter(Mandatory = $true)]
    [string]
    $VaildForYears
)

$secretvalue = ConvertTo-SecureString $Value -AsPlainText -Force

try{
    [int]$yearsToAdd = $VaildForYears
}
catch{
    Write-Error "The parameter VaildForYears is not a vaild number"
    exit -1
}

$Expires = (Get-Date).AddYears($yearsToAdd).ToUniversalTime()
$Nbf = (Get-Date).ToUniversalTime()

Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName -SecretValue $secretvalue -Expires $Expires -NotBefore $Nbf