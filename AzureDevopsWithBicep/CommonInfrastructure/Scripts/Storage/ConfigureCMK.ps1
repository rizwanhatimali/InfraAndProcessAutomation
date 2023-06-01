[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $resourceGroup,
    [Parameter()] 
    $storageAccountName,
    [Parameter()] 
    $keyVaultName,
    [Parameter()] 
    $storageEncryptionKey
)

# Ensure that the storage account for the function app is using managed identity
az storage account update `
--name $storageAccountName  `
--resource-group $resourceGroup `
--assign-identity

# Now get the princiapl id of the storage account identity
$principalId = $(az storage account show --name $storageAccountName `
    --resource-group $resourceGroup `
    --query identity.principalId `
    --output tsv)

# Get a reference to the key vault
$keyVault = $(az keyvault show --name $keyVaultName --resource-group $resourceGroup) | ConvertFrom-Json

# Configure the key vault to allow the storage account to retrieve a key from the key vault to use as the encryption key
az role assignment create --assignee-object-id $principalId `
--role "Key Vault Crypto Service Encryption User" `
--scope $keyVault.id `
--assignee-principal-type 'ServicePrincipal'

# Update the storage account configuration to use a customer managed encryption key stored in the key vault
az storage account update `
--name $storageAccountName `
--resource-group $resourceGroup `
--encryption-key-name $storageEncryptionKey `
--encryption-key-source Microsoft.Keyvault `
--encryption-key-vault $($keyVault.properties.vaultUri)