#Downloads Last 31 days of Disclosures from Rapptr and saves it to the Current Users's user folder in a file called HistoricDisclosures.csv
#Before first use: Please run SavePassword.bat to securely save the password for the specified user
function Get-RequestVerificationToken {
    Param ($LoginUrl, $Session)
    $r = Invoke-WebRequest $LoginUrl -WebSession $Session -UseBasicParsing
    return ($r.InputFields | Where-Object { $_.name -eq "__RequestVerificationToken" }).value
}

function Get-Session {
    Param ($Url, $Email, $Password)
    Invoke-WebRequest $Url -SessionVariable ws -UseBasicParsing | Out-Null
    $loginUrl = $Url + "/login"
    $token = Get-RequestVerificationToken -LoginUrl $loginUrl -Session $ws
    $body = @{
        "__RequestVerificationToken" = $token
        "EmailAddress" = $Email
        "Password" = $Password
    }
    Invoke-WebRequest $loginUrl -Body $body -Method POST -WebSession $ws -UseBasicParsing | Out-Null
    return $ws
}

function Get-LocalSession {
    Param ($URL, $Email, $Password)
    return @{
      "Url" = $URL
      "Session" = Get-Session -Url $URL -Email $Email -Password $Password
    }
}

$url = 'https://<clientName>.fundapps.co'
$email = "<emailAddressOfUserToUse>"
$password = Get-Content "$env:USERPROFILE\EncryptedPassword.txt" | ConvertTo-SecureString
if(!$password)
{
    Write-Error("File $env:USERPROFILE\EncryptedPassword.txt not found, please run SavePassword.bat first")
    exit
}
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($spassword)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$ws = Get-LocalSession -Url $url -Email $email -Password $password
$today = Get-Date -Format yyyy-MM-dd
#Default is Last 31 Days, Change to -10000 for alltime (will take longer to query)
$one_month_ago = Get-Date -date $(Get-Date).AddDays(-31) -format yyyy-MM-dd
$response = Invoke-RestMethod -Uri "$url/api/reporting/disclosures-detailed/export?startDate=$one_month_ago&endDate=$today" -Method Get -WebSession $ws.Session
$csv = $response | ConvertFrom-CSV
$csv | Select-Object Entity,Rule,Key,"Cross date","Due by (UTC)","Filed (UTC)",Value,Assignee,Status | Export-Csv -Path "$env:USERPROFILE\HistoricDisclosures.csv"
