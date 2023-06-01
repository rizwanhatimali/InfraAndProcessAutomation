Write-Host "Installing requred powershell modules"

Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name Az -Scope AllUsers