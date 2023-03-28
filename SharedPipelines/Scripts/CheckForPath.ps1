[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $configPath,
    [Parameter(Mandatory)]
    [string]
    $variableName
)

$hasPath = $false
if(Test-Path -Path $configPath){
    $hasPath = $true
}

Write-Host "Path: $configPath"

Write-Host "##vso[task.setvariable variable=$($variableName)]$hasPath"