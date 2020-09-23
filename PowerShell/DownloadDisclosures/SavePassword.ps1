$credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Set-Content "$env:USERPROFILE\EncryptedPassword.txt"