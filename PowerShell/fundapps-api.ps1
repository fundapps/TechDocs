# FundApps Example PowerShell API Integration
#
# Usage:
# $Result = Expost-Check -APIUri "https://[ALIAS]-api.fundapps.co" -User "user" -Password "pass" -File "TestUpload.xml"
# Get-ValidationState -APIUri "https://[ALIAS]-api.fundapps.co" -User "user" -Password "pass" -Result $Result
# Portfolios-Import -APIUri "https://[ALIAS]-api.fundapps.co" -User "user" -Password "pass" -File "Portfolios.csv"
# Portfolios-Import-Ignore-Unknowns -APIUri "https://[ALIAS]-api.fundapps.co" -User "user" -Password "pass" -File "Portfolios.csv"
# For how to encrypt passwords on a machine before using as a parameter see here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7

function API-Post {
    Param ($Uri, $User, $Password, $File)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));
	$fileName = Split-Path $File -leaf
    $params = @{
        Uri = $Uri
        Method = 'Post'
        Headers = @{ Authorization = $basicAuth; 'X-ContentName' = $fileName}
        ContentType = Get-Content-Type -Filename $File
        InFile = $File
    }
    Invoke-RestMethod @params
}

function API-Get {
    Param ($Uri, $User, $Password)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));
    $params = @{
        Uri = $Uri
        Method = 'Get'
        Headers = @{ Authorization = $basicAuth }
    }
    Invoke-RestMethod @params
}

function Get-Content-Type {
    Param (
        [Parameter(Mandatory=$True)]
        [string] $Filename
    )
    $extension = [System.IO.Path]::GetExtension($Filename)
    $contentType = "Unknown"
    switch($extension)
    {
        '.xls' { $contentType = "application/vnd.ms-excel"}
        '.xlsx' { $contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"}
        '.xml' { $contentType = "application/xml"}
        '.zip' { $contentType = "application/zip" }
        '.csv' { $contentType = "text/csv" }
    }
    return $contentType
}

function Import-File {
  Param ($Uri, $User, $Password, $File)
    API-Post -Uri $Uri -User $User -Password $Password -File $File
}

function Expost-Check {
    Param ($APIUri, $User, $Password, $File)
    Import-File -User $User -Password $Password -File $File -Uri ($APIUri + "/v1/expost/check")
}

function Portfolios-Import {
    Param ($APIUri, $User, $Password, $File)
    Import-File -User $User -Password $Password -File $File -Uri ($APIUri + "/v1/portfolios/import")
}

function Portfolios-Import-Ignore-Unknowns {
    Param ($APIUri, $User, $Password, $File)
    Import-File -User $User -Password $Password -File $File -Uri ($APIUri + "/v1/portfolios/import?ignoreUnknownProperties=true")
}

function Get-ValidationState {
    Param ($APIUri, $User, $Password, $Result)
    $State = Api-Get -Uri ($APIUri + $Result.links.result) -User $User -Password $Password
    $State.ResultsSnapshot
}