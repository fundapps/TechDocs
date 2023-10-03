# FundApps Example PowerShell Adapptr Upload Positions
#
# Usage: First run the script, then call the function below. You might need to run the script with . .\post-data-provider-credentials.ps1 instead of .\post-data-provider-credentials.ps1
# Update-Credentials -User "[USERNAME]" -Password "[PASSWORD]" -DataProviderId "[DATA_PROVIDER_ID]" -DataProviderUsername "[DATA_PROVIDER_USERNAME]" -DataProviderPassword "[DATA_PROVIDER_PASSWORD]" -ClientEnvironment "[ALIAS]"
# For how to encrypt passwords on a machine before using as a parameter see here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7
# If you need to use Bloomberg as a data provider the implementation given below is not applicable
# Please refer to the documentation for more info: https://github.com/fundapps/api-examples#data-provider-credentials-post-restapiv1configurationdataprovidersprovideridcredentials

$isDotSourced = $MyInvocation.InvocationName -eq '.' -or $MyInvocation.Line -eq ''

if (-not $isDotSourced)
{
    Write-Host "You need to source this script, please run using '. .\post-data-provider-credentials.ps1'. The 'dot space' has been omitted."
    Break 1
}

Write-Host "Install functions"

function API-Post-Json {
    Param ($Uri, $User, $Password, $Data)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));

    $params = @{
        Uri = $Uri
        Method = 'Post'
        ContentType = "application/json"
        Headers = @{ Authorization = $basicAuth }
        Body = ConvertTo-Json -InputObject $Data
    }

    try {
        Invoke-RestMethod @params
    }
    catch [System.Net.WebException]{
        if ($_.Exception.Response) {
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd();

            Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
            Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
            Write-Host $_.ErrorDetails.Message
            Write-Host $responseBody
        }
        else{
            throw
        }
    }
}

function Update-Credentials {
    Param ($User, $Password, $DataProviderId, $DataProviderUsername, $DataProviderPassword, $ClientEnvironment)

    $params = @{
        Uri = "https://$ClientEnvironment-svc.fundapps.co/api/adapptr/v2/configuration/dataproviders/$DataProviderId/credentials"
        User = $User
        Password = $Password
        Data = @{
            Username = $DataProviderUsername
            Password = $DataProviderPassword
        }
    }
    Write-Host "Request started"
    API-Post-Json @params
    Write-Host "Done"
}

Write-Host "Functions created"
