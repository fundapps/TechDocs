if (-Not (Test-Path ".\post-data-provider-credentials.ps1"))
{
    Write-Host "Please download the required helper functions from 'https://github.com/fundapps/TechDocs/blob/main/Adapptr/Sample-Code%26Scripts/Powershell/post-data-provider-credentials.ps1' into a file called 'post-data-provider-credentials.ps1'."
    Write-Host "If you have this file locally, you might need to run this script from the folder containing this script."
    Break 1
}

. ".\post-data-provider-credentials.ps1"

$adapptr_username = Read-Host "Adapptr username"
$adapptr_password = Read-Host "Adapptr password" -AsSecureString
$provider = Read-Host "Provider Id (1-Refinitiv 2-Bloomberg)"
$provider_username = Read-Host "Data Provider username"
$provider_password = Read-Host "Data Provider password" -AsSecureString
$env = Read-Host "Entry environment"

$adapptr_password_str = (New-Object PSCredential 0, $adapptr_password).GetNetworkCredential().Password
$provider_password_str = (New-Object PSCredential 0, $provider_password).GetNetworkCredential().Password

# Update-Credentials -User "[USERNAME]" -Password "[PASSWORD]" -DataProviderId "[DATA_PROVIDER_ID]" -DataProviderUsername "[DATA_PROVIDER_USERNAME]" -DataProviderPassword "[DATA_PROVIDER_PASSWORD]" -ClientEnvironment "[ALIAS]"
Update-Credentials -User $adapptr_username -Password $adapptr_password_str -DataProviderId $provider -DataProviderUsername $provider_username -DataProviderPassword $provider_password_str -ClientEnvironment $env
