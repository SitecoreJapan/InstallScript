$thumbprint = (New-SelfSignedCertificate -Subject "CN=$env:COMPUTERNAME @ Sitecore, Inc." -Type SSLServerAuthentication -FriendlyName "$env:USERNAME Certificate").Thumbprint
$certificateFilePath = "C:\projects\sitecoreonazure\sitecoreonazuredemo.pfx"
Export-PfxCertificate -cert cert:\LocalMachine\MY\$thumbprint -FilePath "$certificateFilePath" -Password (Read-Host -Prompt "Enter password that would protect the certificate" -AsSecureString)
