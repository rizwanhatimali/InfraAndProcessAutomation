[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,
    # The name of the Function app to update
    [Parameter(Mandatory = $true)]
    [string]
    $Name,
    [Parameter(Mandatory = $true)]
    [string]
    $environment,
    # Json file containing the application settings to apply
    [Parameter(Mandatory = $true)]
    [string]
    $JsonFilePath
)

function Get-ValueFromProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $setting,
        [Parameter(Mandatory = $true)]
        $env,
        [Parameter(Mandatory = $true)]
        $resourceGroupName
    )

    switch ($setting.Type) {
        "Resource" { return Get-ValueFromResource -resource $setting.resource -env $env -resourceGroupName $resourceGroupName }
        "KeyVault" { return Get-ValueFromKeyVault -keyVault $setting.keyVault -env $env }
        "string" { return Get-StringValue -setting $setting -env $env }
        Default { return $null }
    }
}

function Get-StringValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $setting,
        [Parameter(Mandatory = $true)]
        $env
    )

    if ($null -eq $setting.addEnv -or $false -eq $setting.addEnv) {
        return $setting.value
    }

    return $("$($setting.value)$env").ToLowerInvariant()
}

function Get-ValueFromResource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $resource,
        [Parameter(Mandatory = $true)]
        $env,
        [Parameter(Mandatory = $true)]
        $resourceGroupName
    )

    switch ($resource.type) {
        "eventGridTopic" { return Get-ValueFromEventGridTopic -resource $resource -env $env -resourceGroupName $resourceGRoupName }
        "storageAccount" { return Get-ValueFromStorageAccount -resource $resource -env $env -resourceGroupName $resourceGRoupName }
        "appInsights" { return Get-ValueFromApplicationInsights -resource $resource -env $env -resourceGroupName $resourceGRoupName }
        Default { return $null }
    }
}

function Get-ValueFromEventGridTopic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $resource,
        [Parameter(Mandatory = $true)]
        $env,
        [Parameter(Mandatory = $true)]
        $resourceGroupName
    )

    $name = "$($resource.name)$env"
    $result = Get-AzEventGridTopic -ResourceGroupName $resourceGroupName -Name $name -ErrorAction Continue

    if ($null -eq $result) {
        return $null
    }

    return $result."$($resource.property)"
}

function Get-ValueFromStorageAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $resource,
        [Parameter(Mandatory = $true)]
        $env,
        [Parameter(Mandatory = $true)]
        $resourceGroupName
    )

    $name = $("$($resource.name)$env").ToLowerInvariant()
    $result = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $name -ErrorAction Continue

    if ($null -eq $result) {
        return $null
    }

    $properties = $resource.property.Split(".")

    $retVal = $result

    foreach ($prop in $properties) {
        $retVal = $retVal."$($prop)"
    }

    return $retVal
}

function Get-ValueFromApplicationInsights{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $resource,
        [Parameter(Mandatory = $true)]
        $resourceGroupName,
        [Parameter(Mandatory = $true)]
        $env
    )

    $name = $("$($resource.name)$env").ToLowerInvariant()
    
    $result = Get-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $name

    if ($null -eq $result) {
        return $null
    }

    $properties = $resource.property.Split(".")

    $retVal = $result

    foreach ($prop in $properties) {
        $retVal = $retVal."$($prop)"
    }

    return $retVal
}

function Get-ValueFromKeyVault {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $keyVault,
        [Parameter(Mandatory = $true)]
        $env
        
    )

    return "@Microsoft.KeyVault(VaultName=$($keyVault.name)$($env);SecretName=$($keyVault.key))"
}




$appSettings = @{}

if (-Not (Test-Path -Path $JsonFilePath)) {
    Write-Host "No configuration setting to apply"
    exit 0
}

$functionAppSettings = ConvertFrom-Json (Get-Content -Raw -Path $JsonFilePath)

foreach ($setting in $functionAppSettings) {
    $value = Get-ValueFromProvider -setting $setting -env $environment -resourceGroupName $ResourceGroupName

    if ($null -ne $value) {
        $appSettings.Add($setting.name, $value)
    }
}

Update-AzFunctionAppSetting -Name $Name -ResourceGroupName $ResourceGroupName -AppSetting $appSettings -Force 