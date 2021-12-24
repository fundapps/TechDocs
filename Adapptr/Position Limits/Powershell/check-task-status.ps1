# FundApps Example PowerShell Adapptr Upload Positions
#
# Usage: First run the script, then call the function below. You might need to run the script with . .\check-task-status.ps1 instead of .\check-task-status.ps1
#Get-Status -APIUri "[BASEURL]" -User "[USERNAME]" -Password "[PASSWORD]" -TaskId "[TASKID]"  -ClientEnvironment "[ALIAS]"
# For how to encrypt passwords on a machine before using as a parameter see here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7

Write-Host "Install functions"

function API-GET {
    Param ($Uri, $User, $Password, $ClientEnvironment)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));

    $params = @{
        Uri = $Uri
        Method = 'Get'
        Headers = @{ Authorization = $basicAuth; 'X-Client-Environment' = $ClientEnvironment}
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

function Get-Status {
    Param ($APIUri, $User, $Password, $TaskId, $ClientEnvironment)

    $params = @{
        Uri = "$APIUri/rest/api/v1/task/$TaskId/status"
        User = $User
        Password = $Password
        ClientEnvironment = $ClientEnvironment
    }
    Write-Host "Request started"
    API-GET @params
    Write-Host "Done"
}

Write-Host "Done"
