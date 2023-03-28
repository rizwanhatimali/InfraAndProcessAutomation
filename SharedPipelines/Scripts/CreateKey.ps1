[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $KeyVaultName,
    [Parameter(Mandatory = $true)]
    [string]
    $KeyName,
    # The number of years before the secret expires
    [Parameter(Mandatory = $true)]
    [string]
    $VaildForYears
)

try{
    [int]$yearsToAdd = $VaildForYears
}
catch{
    Write-Error "The parameter VaildForYears is not a vaild number"
    exit -1
}

$Expires = (Get-Date).AddYears($yearsToAdd).ToUniversalTime()
$Nbf = (Get-Date).ToUniversalTime()

Add-AzKeyVaultKey -VaultName $KeyVaultName -Name $KeyName -Expires $Expires -NotBefore $Nbf -KeyType RSA -Destination Software