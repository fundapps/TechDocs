#
# Usage: First run the script, then call the function below. You might need to run the script with . .\upload-positions.ps1 instead of .\upload-positions.ps1
# Import-Positions -User "[USERNAME]" -Password "[PASSWORD]" -File "[PATH_TO_FILE]" -ClientEnvironment "[ALIAS]"
# For how to encrypt passwords on a machine before using as a parameter see here: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7

Write-Host "Install functions"

function API-Post {
    Param ($Uri, $User, $Password, $File)
    $basicAuth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($User) + ":" + $($Password)));

    $fileBytes = [System.IO.File]::ReadAllBytes($File);
    $fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);
    $boundary = [System.Guid]::NewGuid().ToString();
    $LF = "`r`n";
    $snapshotDate = Get-Date -Format "yyyy-MM-dd";

    # please refer to the documentation for more info on parameters:
    # https://github.com/fundapps/TechDocs/blob/main/Adapptr/versions/v2.md#available-nomenclatures-get-v2nomenclatures
    # https://github.com/fundapps/TechDocs/blob/main/Adapptr/versions/v2.md#upload-positions-without-enrichment-post-v2taskpositionswithout-enrichment

    $format = "2";

    $bodyLines = (
        "--$boundary",
        "Content-Disposition: form-data; name=`"snapshotDate`"$LF",
        "$snapshotDate$LF",
        "--$boundary",
        "Content-Disposition: form-data; name=`"format`"$LF",
        "$format$LF",
        "--$boundary",
        "Content-Disposition: form-data; name=`"positions`"; filename=`"positions.csv`"",
        "Content-Type: application/octet-stream$LF",
        $fileEnc,
        "--$boundary--$LF"
    ) -join $LF

    $params = @{
        Uri = $Uri
        Method = 'Post'
        ContentType = "multipart/form-data; boundary=`"$boundary`""
        Headers = @{ Authorization = $basicAuth }
        Body = $bodyLines
    }

    try {
        Invoke-RestMethod @params
    }
    catch [System.Net.WebException]{
        if($_.Exception.Response){
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
function Get-Content-Type {
    Param (
        [Parameter(Mandatory=$True)]
        [string] $Filename
    )
    $extension = [System.IO.Path]::GetExtension($Filename)
    $contentType = "Unknown"

    switch($extension)
    {
        '.csv' { $contentType = "text/csv" }
    }

    return $contentType
}

function Import-File {
  Param ($Uri, $User, $Password, $File)
    Write-Host "Request started"
    API-Post -Uri $Uri -User $User -Password $Password -File $File
    Write-Host "Done"
}


function Import-Positions {
    Param ($User, $Password, $File, $ClientEnvironment)
    Import-File -User $User -Password $Password -File $File -Uri "https://$ClientEnvironment-svc.fundapps.co/api/adapptr/v2/task/positions/without-enrichment"
}

Write-Host "Functions created"
