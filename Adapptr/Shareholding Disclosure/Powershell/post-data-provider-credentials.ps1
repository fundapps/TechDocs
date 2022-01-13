# FundApps Example PowerShell Adapptr Upload Positions
#
# Usage: First run the script, then call the function below. You might need to run the script with . .\post-data-provider-credentials.ps1 instead of .\post-data-provider-credentials.ps1
# Update-Credentials  -APIUri "[BASEURL]" -User "[USERNAME]" -Password "[PASSWORD]" -DataProviderId "[DATA_PROVIDER_ID]" -DataProviderUsername "[DATA_PROVIDER_USERNAME]" -DataProviderPassword "[DATA_PROVIDER_PASSWORD]" -ClientEnvironment "[ALIAS]"
# For how to encrypt passwords on a machine before using as a parameter see here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7
# If you need to use Bloomberg as a data provider the implementation given below is not applicable
# Please refer to the documentation for more info: https://github.com/fundapps/api-examples#data-provider-credentials-post-restapiv1configurationdataprovidersprovideridcredentials

Write-Host "Install functions"

function API-Post-Json {
    Param ($Uri, $User, $Password, $Data, $ClientEnvironment)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));

    $params = @{
        Uri = $Uri
        Method = 'Post'
        ContentType = "application/json"
        Headers = @{ Authorization = $basicAuth; 'X-Client-Environment' = $ClientEnvironment}
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
    Param ($APIUri, $User, $Password, $DataProviderId, $DataProviderUsername, $DataProviderPassword, $ClientEnvironment)
    Write-Host ("$APIUri/rest/api/v1/dataproviders/$DataProviderId/credentials")

    $params = @{
        Uri = "$APIUri/rest/api/v1/configuration/dataproviders/$DataProviderId/credentials"
        User = $User
        Password = $Password
        Data = @{
            Username = $DataProviderUsername
            Password = $DataProviderPassword
        }
        ClientEnvironment = $ClientEnvironment
    }
    Write-Host "Request started"
    API-Post-Json @params
    Write-Host "Done"
}

Write-Host "Done"
